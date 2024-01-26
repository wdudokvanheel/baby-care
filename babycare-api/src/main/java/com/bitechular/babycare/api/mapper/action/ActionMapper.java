package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.data.model.BabyActionType;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActionMapper {
    private ModelMapper mapper;
    private Map<Class<? extends BabyAction>, AbstractBabyActionToDtoMapper> actionMappers = new HashMap<>();
    private Map<BabyActionType, AbstractBabyActionToDtoMapper> actionMappersByType = new HashMap<>();

    public ActionMapper(ModelMapper mapper, List<AbstractBabyActionToDtoMapper> mappers) {
        this.mapper = mapper;
        for (AbstractBabyActionToDtoMapper dtoMapper : mappers) {
            actionMappers.put(dtoMapper.getActionClass(), dtoMapper);
            actionMappersByType.put(dtoMapper.forType(), dtoMapper);
        }
    }

    public BabyAction fromCreateDto(ActionCreateRequest dto) {
        AbstractBabyActionToDtoMapper actionMapper = actionMappersByType.get(dto.type);

        if (actionMapper != null) {
            return actionMapper.fromCreateDto(dto);
        }

        return mapper.map(dto, BabyAction.class);
    }

    public BabyAction fromUpdateDto(BabyAction action, ActionUpdateRequest dto) {
        AbstractBabyActionToDtoMapper actionMapper = actionMappersByType.get(action.getType());

        if (actionMapper != null) {
            return actionMapper.fromUpdateDto(action, dto);
        }

        mapper.map(dto, action);
        return action;
    }

    public BabyActionDto toDto(BabyAction action) {
        AbstractBabyActionToDtoMapper actionMapper = actionMappers.get(action.getClass());

        if (actionMapper != null) {
            return actionMapper.toDto(action);
        }

        // If no custom action mapper is found, fall back to a plain BabyActionDto
        return mapper.map(action, BabyActionDto.class);
    }

    public Class<? extends ActionUpdateRequest> getUpdateRequestType(BabyActionType type) {
        AbstractBabyActionToDtoMapper actionMapper = actionMappersByType.get(type);

        if (actionMapper != null) {
            return actionMapper.getUpdateRequestClass();
        }

        // If no custom action mapper is found, fall back to a plain UpdateRequest
        return ActionUpdateRequest.class;
    }
}
