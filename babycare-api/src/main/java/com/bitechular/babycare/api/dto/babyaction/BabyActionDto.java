package com.bitechular.babycare.api.dto.babyaction;

import com.bitechular.babycare.data.model.BabyActionType;

import java.util.Date;

public class BabyActionDto {
    public long id;
    public long babyId;
    public BabyActionType type;
    public Date start;
    public Date end;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getBabyId() {
        return babyId;
    }

    public void setBabyId(long babyId) {
        this.babyId = babyId;
    }

    public BabyActionType getType() {
        return type;
    }

    public void setType(BabyActionType type) {
        this.type = type;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }
}
