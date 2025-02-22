package com.bitechular.babycare.api.dto.babyaction;

import com.bitechular.babycare.api.dto.babyaction.bottle.BottleActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.feed.FeedActionCreateRequest;
import com.bitechular.babycare.api.dto.babyaction.sleep.SleepActionCreateRequest;
import com.bitechular.babycare.data.model.BabyActionType;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

import java.util.Date;

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type", visible = true)
@JsonSubTypes({
        @JsonSubTypes.Type(value = SleepActionCreateRequest.class, name = "SLEEP"),
        @JsonSubTypes.Type(value = FeedActionCreateRequest.class, name = "FEED"),
        @JsonSubTypes.Type(value = BottleActionCreateRequest.class, name = "BOTTLE")
})
public class ActionCreateRequest {
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
