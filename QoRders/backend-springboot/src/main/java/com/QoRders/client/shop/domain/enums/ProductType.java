package com.QoRders.client.shop.domain.enums;

public enum ProductType {
    STARTER("Starter"),
    MAIN_COURSE("Main Course"),
    DESSERT("Dessert"),
    DRINK("Drink"),
    OTHER("Other");

    private final String value;

    ProductType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static ProductType fromValue(String value) {
        for (ProductType type : ProductType.values()) {
            if (type.getValue().equalsIgnoreCase(value)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown value: " + value);
    }
}