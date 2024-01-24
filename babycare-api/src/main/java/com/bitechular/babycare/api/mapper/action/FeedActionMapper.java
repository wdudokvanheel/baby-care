package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.FeedActionDto;
import com.bitechular.babycare.data.model.FeedAction;
import org.springframework.stereotype.Service;

@Service
public class FeedActionMapper extends AbstractBabyActionToDtoMapper<FeedAction> {
    @Override
    public FeedActionDto toDto(FeedAction action) {
        return mapper.map(action, FeedActionDto.class);
    }
}
