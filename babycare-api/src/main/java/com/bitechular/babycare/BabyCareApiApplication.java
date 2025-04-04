package com.bitechular.babycare;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

import java.util.TimeZone;

@SpringBootApplication(exclude = {UserDetailsServiceAutoConfiguration.class})
@EnableJpaRepositories("com.bitechular.babycare.data")
public class BabyCareApiApplication {
    private static Logger logger = LoggerFactory.getLogger(BabyCareApiApplication.class);

    public static void main(String[] args) {
        String conf = System.getProperty("conf");
        if (conf == null || conf.length() < 0) {
            System.setProperty("conf", "/api.conf");
        }

        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        SpringApplication.run(BabyCareApiApplication.class, args);
    }
}
