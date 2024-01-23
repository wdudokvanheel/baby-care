package com.bitechular.babycare.api.mapper;

import com.bitechular.babycare.api.dto.babyaction.BabyActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;
import com.bitechular.babycare.api.dto.babyaction.BabyActionUpdateRequest;
import com.bitechular.babycare.data.model.BabyAction;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class BabyActionMapper {
    private ModelMapper mapper;

    public BabyActionMapper(ModelMapper mapper) {
        this.mapper = mapper;
    }

    public BabyAction fromCreateDto(BabyActionCreateRequest dto) {
        BabyAction action = mapper.map(dto, BabyAction.class);
        return action;
    }

    public BabyAction fromUpdateDto(BabyAction action, BabyActionUpdateRequest dto) {
        mapper.map(dto, action);
        return action;
    }

    public BabyActionDto toDto(BabyAction action) {
        return mapper.map(action, BabyActionDto.class);
    }
}
