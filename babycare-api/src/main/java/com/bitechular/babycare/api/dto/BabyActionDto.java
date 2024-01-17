package com.bitechular.babycare.api.dto;

import com.bitechular.babycare.data.model.BabyActionType;

import java.util.Date;

public class BabyActionDto {
    public Long id;
    public BabyActionType type;
    public Date start;
    public Date end;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
