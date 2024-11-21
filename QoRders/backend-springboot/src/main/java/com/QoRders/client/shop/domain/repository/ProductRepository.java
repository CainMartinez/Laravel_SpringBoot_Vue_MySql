package com.QoRders.client.shop.domain.repository;

import com.QoRders.client.shop.domain.entity.ProductEntity;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

@Repository
public interface ProductRepository extends PagingAndSortingRepository<ProductEntity, Integer> {

    @Query(value = """
        SELECT * 
        FROM Products p
        LIMIT :limit OFFSET :offset
    """, nativeQuery = true)

    List<ProductEntity> findAllWithPagination(@Param("limit") int limit, @Param("offset") int offset);

    @Query(value = """
        SELECT p.* 
        FROM Products p
        LEFT JOIN NGO n ON p.origin = n.country
        LEFT JOIN Room r ON n.ngo_id = r.ngo_id
        WHERE (r.room_slug = :slug AND p.origin = n.country)
        OR p.origin = 'Generic'
        LIMIT :limit OFFSET :offset
    """, nativeQuery = true)
    
    List<ProductEntity> findProductsByRoomSlug(
            @Param("slug") String slug,
            @Param("limit") int limit,
            @Param("offset") int offset
    );
}