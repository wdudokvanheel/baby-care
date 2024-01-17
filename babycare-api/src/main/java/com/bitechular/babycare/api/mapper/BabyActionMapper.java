package com.bitechular.babycare.api.mapper;

import com.bitechular.babycare.api.dto.BabyActionCreateRequestDto;
import com.bitechular.babycare.api.dto.BabyActionDto;
import com.bitechular.babycare.api.dto.BabyActionUpdateRequestDto;
import com.bitechular.babycare.data.model.BabyAction;
import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class BabyActionMapper {
    private Logger logger = LoggerFactory.getLogger(BabyActionMapper.class);

    private ModelMapper mapper;

    public BabyActionMapper(ModelMapper mapper) {
        this.mapper = mapper;
    }

    public BabyAction fromCreateDto(BabyActionCreateRequestDto dto) {
        BabyAction action = mapper.map(dto, BabyAction.class);
        return action;
    }

    public BabyAction fromUpdateDto(BabyAction action, BabyActionUpdateRequestDto dto) {
        mapper.map(dto, action);
        return action;
    }

    public BabyActionDto toDto(BabyAction action) {
        return mapper.map(action, BabyActionDto.class);
    }
}
