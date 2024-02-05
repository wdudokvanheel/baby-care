package com.bitechular.babycare.api.mapper.action;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.api.dto.babyaction.feed.FeedActionDto;
import com.bitechular.babycare.api.dto.babyaction.feed.FeedActionUpdateRequest;
import com.bitechular.babycare.data.model.BabyActionType;
import com.bitechular.babycare.data.model.FeedAction;
import org.springframework.stereotype.Service;

@Service
public class FeedActionMapper extends AbstractBabyActionToDtoMapper<FeedAction> {
    @Override
    public FeedActionDto toDto(FeedAction action) {
        return mapper.map(action, FeedActionDto.class);
    }

    @Override
    public FeedAction fromCreateDto(ActionCreateRequest dto) {
        return mapper.map(dto, FeedAction.class);
    }

    @Override
    public FeedAction fromUpdateDto(FeedAction action, ActionUpdateRequest dto) {
        mapper.map(dto, action);
        return action;
    }

    @Override
    public BabyActionType forType() {
        return BabyActionType.FEED;
    }

    @Override
    public Class<? extends ActionUpdateRequest> getUpdateRequestClass() {
        return FeedActionUpdateRequest.class;
    }
}
