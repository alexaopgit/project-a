package org.my.controller;

import org.my.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
public class GeneralController {

    @Autowired
    private ShopService shopService;

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(
            value = "/",
            method = RequestMethod.GET,
            produces = "application/json; charset=utf-8"
    )
    public String index(@RequestParam(required = true) String product) {
        return "Mode1: " + shopService.findPrices(product).toString() + "\nMode2: " +
                shopService.findPrices2(product) + "\n";
    }
}
