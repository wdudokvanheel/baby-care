package com.bitechular.babycare;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories("com.bitechular.babycare.data")
public class BabyCareApiApplication{
	public static void main(String[] args){
		SpringApplication.run(BabyCareApiApplication.class, args);
	}
}
