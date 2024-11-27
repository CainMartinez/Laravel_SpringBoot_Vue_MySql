package com.QoRders.client.shop.infra.spec;

import com.QoRders.client.shop.domain.entity.ProductEntity;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import org.springframework.data.jpa.domain.Specification;

public class ProductSpecification {

    public static Specification<ProductEntity> withSlugAndType(String slug, String productType) {
        return (root, query, criteriaBuilder) -> {
            Join<Object, Object> ngoJoin = root.join("country", JoinType.INNER);

            Join<Object, Object> roomJoin = ngoJoin.join("room", JoinType.INNER);

            var slugPredicate = criteriaBuilder.equal(roomJoin.get("roomSlug"), slug);

            var typePredicate = productType != null && !productType.isBlank()
                    ? criteriaBuilder.equal(root.get("productType"), productType)
                    : criteriaBuilder.conjunction();

            var finalPredicate = criteriaBuilder.or(
                    criteriaBuilder.and(slugPredicate, typePredicate));

            return finalPredicate;
        };
    }
}