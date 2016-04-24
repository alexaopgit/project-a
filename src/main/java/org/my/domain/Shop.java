package org.my.domain;

/**
 * Shop simple model
 */
public class Shop {
    /**
     * Shop name
     */
    private String name;

    /**
     * Constructor where you have to provide the name of the shop
     *
     * @param name shop name
     */
    public Shop(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
