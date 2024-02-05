package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.api.dto.babyaction.sleep.SleepActionDto;
import com.bitechular.babycare.api.dto.babyaction.sleep.SleepActionUpdateRequest;
import com.bitechular.babycare.data.model.BabyActionType;
import com.bitechular.babycare.data.model.SleepAction;
import org.springframework.stereotype.Service;

@Service
public class SleepActionMapper extends AbstractBabyActionToDtoMapper<SleepAction> {
    @Override
    public SleepActionDto toDto(SleepAction action) {
        return mapper.map(action, SleepActionDto.class);
    }

    @Override
    public SleepAction fromCreateDto(ActionCreateRequest dto) {
        return mapper.map(dto, SleepAction.class);
    }

    @Override
    public SleepAction fromUpdateDto(SleepAction action, ActionUpdateRequest dto) {
        mapper.map(dto, action);
        return action;
    }

    @Override
    public BabyActionType forType() {
        return BabyActionType.SLEEP;
    }

    @Override
    public Class<? extends ActionUpdateRequest> getUpdateRequestClass() {
        return SleepActionUpdateRequest.class;
    }
}
