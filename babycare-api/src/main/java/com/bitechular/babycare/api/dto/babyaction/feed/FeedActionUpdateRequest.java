package com.bitechular.babycare.api.dto.babyaction.feed;

import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;
import com.bitechular.babycare.data.model.FeedSide;

public class FeedActionUpdateRequest extends ActionUpdateRequest {
    public FeedSide side;

    public FeedSide getSide() {
        return side;
    }

    public void setSide(FeedSide side) {
        this.side = side;
    }
}
