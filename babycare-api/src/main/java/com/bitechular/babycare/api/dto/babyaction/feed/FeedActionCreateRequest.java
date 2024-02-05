package com.bitechular.babycare.api.dto.babyaction.feed;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;
import com.bitechular.babycare.data.model.FeedSide;

public class FeedActionCreateRequest extends ActionCreateRequest {
    public FeedSide side;

    public FeedSide getSide() {
        return side;
    }

    public void setSide(FeedSide side) {
        this.side = side;
    }
}
