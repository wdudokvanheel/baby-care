package com.bitechular.babycare;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

import java.util.TimeZone;

@SpringBootApplication(exclude = {UserDetailsServiceAutoConfiguration.class})
@EnableJpaRepositories("com.bitechular.babycare.data")
public class BabyCareApiApplication {
    public static void main(String[] args) {
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
        SpringApplication.run(BabyCareApiApplication.class, args);
    }
}
