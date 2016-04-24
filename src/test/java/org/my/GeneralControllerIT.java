package org.my;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Arrays;

import static org.hamcrest.Matchers.stringContainsInOrder;
import static org.junit.Assert.assertThat;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@WebAppConfiguration
@IntegrationTest({"server.port=0"})
public class GeneralControllerIT {

    @Value("${local.server.port}")
    private int port;

    //    private URL base;
    private RestTemplate template;
    private UriComponentsBuilder builder;

    @Before
    public void setUp() throws Exception {
        builder = UriComponentsBuilder.fromHttpUrl("http://localhost:" + port + "/").queryParam("product", "iphone");
        template = new TestRestTemplate();
    }

    @Test
    public void getPrices() throws Exception {
        ResponseEntity<String> response = template.getForEntity(builder.build().toUri(), String.class);
        assertThat(response.getBody(), stringContainsInOrder(Arrays.asList("Shop A", "Shop B", "Shop C", "Shop D")));
    }
}