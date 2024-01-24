package com.bitechular.babycare.api.dto.babyaction;

import com.bitechular.babycare.data.model.FeedSide;

public class FeedActionDto extends BabyActionDto {
    public FeedSide side;

    public FeedSide getSide() {
        return side;
    }

    public void setSide(FeedSide side) {
        this.side = side;
    }
}
