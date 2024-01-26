package com.bitechular.babycare.configuration;

import com.bitechular.babycare.configuration.spring.resolver.UpdateActionRequestBodyArgumentResolver;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    private UpdateActionRequestBodyArgumentResolver resolver;

    public WebConfig(UpdateActionRequestBodyArgumentResolver resolver) {
        this.resolver = resolver;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(resolver);
    }
}
