package com.bitechular.babycare.controller.dto.mapper;

import com.bitechular.babycare.controller.dto.BabyActionCreateDto;
import com.bitechular.babycare.controller.dto.BabyActionUpdateDto;
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

    public BabyAction fromCreateDto(BabyActionCreateDto dto) {
        BabyAction action = mapper.map(dto, BabyAction.class);
        return action;
    }

    public BabyAction fromUpdateDto(BabyAction action, BabyActionUpdateDto dto) {
        mapper.map(dto, action);
        return action;
    }
}
