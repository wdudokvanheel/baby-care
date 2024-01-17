package com.bitechular.babycare.api.dto;

import com.bitechular.babycare.data.model.BabyActionType;

import java.util.Date;

public class BabyActionCreateRequestDto {
    public BabyActionType type;
    public Date start;
    public Date end;

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
