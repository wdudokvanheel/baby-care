package com.bitechular.babycare.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

/**
 * Bitechular Innovations
 *
 * @Author Wesley Dudok van Heel
 */
@Configuration
@PropertySource("file:${conf}")
public class PropertyFileConfiguration {
}
