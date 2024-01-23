package com.bitechular.babycare.configuration;

import com.bitechular.babycare.data.model.Baby;
import org.modelmapper.Converter;
import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ModelMapperConfiguration {
    @Bean
    public ModelMapper modelMapper() {
        ModelMapper mapper = new ModelMapper();
        Converter<Baby, Long> babyToIdConverter = context -> context.getSource() == null ? null : context.getSource().getId();
        mapper.addConverter(babyToIdConverter);
        return mapper;
    }
}

