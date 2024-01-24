package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.BabyActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;
import com.bitechular.babycare.api.dto.babyaction.BabyActionUpdateRequest;
import com.bitechular.babycare.data.model.BabyAction;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BabyActionMapper {
    private ModelMapper mapper;
    private Map<Class<? extends BabyAction>, AbstractBabyActionToDtoMapper> actionMappers = new HashMap<>();

    public BabyActionMapper(ModelMapper mapper, List<AbstractBabyActionToDtoMapper> mappers) {
        this.mapper = mapper;
        for (AbstractBabyActionToDtoMapper dtoMapper : mappers) {
            actionMappers.put(dtoMapper.getActionClass(), dtoMapper);
        }
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
        AbstractBabyActionToDtoMapper actionMapper = actionMappers.get(action.getClass());

        if (actionMapper != null) {
            return actionMapper.toDto(action);
        }

        return mapper.map(action, BabyActionDto.class);
    }
}
