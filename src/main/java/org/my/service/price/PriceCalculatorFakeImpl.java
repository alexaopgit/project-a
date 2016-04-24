package org.my.service.price;

import org.springframework.stereotype.Service;

import java.util.Random;

/**
 * Real implementation would query the shop's database or other time-consumed operation.
 * This is an implementation witch emulate price calculation and in fact uses randomly generated number.
 */
@Service
public class PriceCalculatorFakeImpl implements PriceCalculator {
    /**
     * Random number generator
     */
    private static Random random = new Random();

    @Override
    public double calculatePrise(String product) {
        delay();
        return random.nextDouble() * product.charAt(0) + product.charAt(1);
    }

    public static void delay() {
        try {
            Thread.sleep(1000L);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
