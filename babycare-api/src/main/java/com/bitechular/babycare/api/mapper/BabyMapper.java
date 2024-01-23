package com.bitechular.babycare.api.mapper;

import com.bitechular.babycare.api.dto.baby.BabyDto;
import com.bitechular.babycare.data.model.Baby;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class BabyMapper {
    private ModelMapper mapper;

    public BabyMapper(ModelMapper mapper) {
        this.mapper = mapper;
    }

    public BabyDto toDto(Baby baby) {
        return mapper.map(baby, BabyDto.class);
    }
}
