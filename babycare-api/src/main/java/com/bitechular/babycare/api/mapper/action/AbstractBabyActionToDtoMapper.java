package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;
import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.data.model.BabyActionType;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.reflect.ParameterizedType;

public abstract class AbstractBabyActionToDtoMapper<Action extends BabyAction> {
    protected ModelMapper mapper;

    @Autowired
    public void setObjectMapper(ModelMapper mapper) {
        this.mapper = mapper;
    }

    public abstract BabyActionDto toDto(Action action);
    public abstract Action fromCreateDto(ActionCreateRequest dto);
    public abstract Action fromUpdateDto(Action action, ActionUpdateRequest dto);

    public abstract BabyActionType forType();
    public abstract Class<? extends ActionUpdateRequest> getUpdateRequestClass();

    public Class<Action> getActionClass() {
        return (Class<Action>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
    }
}
