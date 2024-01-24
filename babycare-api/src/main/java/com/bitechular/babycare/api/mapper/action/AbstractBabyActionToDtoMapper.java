package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;
import com.bitechular.babycare.data.model.BabyAction;
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

    public Class<Action> getActionClass() {
        return (Class<Action>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
    }
}
