package com.QoRders.client.shop.domain.converter;

import com.QoRders.client.shop.domain.enums.ProductType;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class ProductTypeConverter implements AttributeConverter<ProductType, String> {

    @Override
    public String convertToDatabaseColumn(ProductType productType) {
        if (productType == null) {
            return null;
        }
        return productType.getValue();
    }

    @Override
    public ProductType convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        return ProductType.fromValue(dbData);
    }
}