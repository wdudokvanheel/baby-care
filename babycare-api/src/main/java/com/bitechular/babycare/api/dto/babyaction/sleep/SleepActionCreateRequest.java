package com.bitechular.babycare.api.dto.babyaction.sleep;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;

public class SleepActionCreateRequest extends ActionCreateRequest {
    public boolean night;

    public boolean isNight() {
        return night;
    }

    public void setNight(boolean night) {
        this.night = night;
    }
}
