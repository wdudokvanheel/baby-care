package com.bitechular.babycare.data.model;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

@Entity
@Table(name = "FeedAction")
public class FeedAction extends BabyAction {
    @Enumerated(EnumType.STRING)
    private FeedSide side;

    public FeedSide getSide() {
        return side;
    }

    public void setSide(FeedSide side) {
        this.side = side;
    }
}
