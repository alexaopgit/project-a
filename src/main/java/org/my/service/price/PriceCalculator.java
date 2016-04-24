package org.my.service.price;

/**
 * Prise calculator main interface
 */
public interface PriceCalculator {
    /**
     * Calculate prise of the specified product.
     * This method has to be thread safety.
     *
     * @param product product
     * @return the product prise
     */
    double calculatePrise(String product);
}
