package org.my.service;

import org.my.domain.Shop;
import org.my.service.price.PriceCalculator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import static java.util.stream.Collectors.toList;

/**
 * Shop services. At this moment it provides only product findPrice service
 */
@Service
public class ShopService {
    /**
     * Shop list predefined
     */
    private List<Shop> shops;

    /**
     * Price calculator. Here we take a fake implementation
     */
    @Autowired
    private PriceCalculator priceCalculator;

    /**
     * Class initialization on Spring Context loading
     */
    @PostConstruct
    public void init() {
        shops = Arrays.asList(new Shop("Shop A"), new Shop("Shop B"), new Shop("Shop C"), new Shop("Shop D"));
    }

    /**
     * Get the price of specified product.
     *
     * @param product product code
     * @return product prise
     */
    private double getPrice(String product) {
        return priceCalculator.calculatePrise(product);
    }


    /**
     * Finding prices using parallel Stream
     *
     * @param product product
     * @return list of prices
     */
    public List<String> findPrices(String product) {
        return shops.parallelStream()
                .map(shop -> String.format("%s price is %.2f", shop.getName(), getPrice(product)))
                .collect(toList());
    }

    /**
     * Finding prices using CompletableFuture
     *
     * @param product product
     * @return list of prices
     */
    public List<String> findPrices2(String product) {
        List<CompletableFuture<String>> pricesFuture = shops.stream()
                .map(shop -> CompletableFuture.supplyAsync(
                        () -> String.format("%s price is %.2f", shop.getName(), getPrice(product))
                ))
                .collect(toList());
        return pricesFuture.stream().map(CompletableFuture::join).collect(toList());
    }
}
