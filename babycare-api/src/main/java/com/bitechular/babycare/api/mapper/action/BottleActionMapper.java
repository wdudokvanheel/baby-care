package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.api.dto.babyaction.BottleActionDto;
import com.bitechular.babycare.api.dto.babyaction.BottleActionUpdateRequest;
import com.bitechular.babycare.data.model.BabyActionType;
import com.bitechular.babycare.data.model.BottleAction;
import org.springframework.stereotype.Service;

@Service
public class BottleActionMapper extends AbstractBabyActionToDtoMapper<BottleAction> {
    @Override
    public BottleActionDto toDto(BottleAction action) {
        return mapper.map(action, BottleActionDto.class);
    }

    @Override
    public BottleAction fromCreateDto(ActionCreateRequest dto) {
        return mapper.map(dto, BottleAction.class);
    }

    @Override
    public BottleAction fromUpdateDto(BottleAction action, ActionUpdateRequest dto) {
        mapper.map(dto, action);
        return action;
    }

    @Override
    public BabyActionType forType() {
        return BabyActionType.BOTTLE;
    }

    @Override
    public Class<? extends ActionUpdateRequest> getUpdateRequestClass() {
        return BottleActionUpdateRequest.class;
    }
}
