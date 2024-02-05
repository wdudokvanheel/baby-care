package com.bitechular.babycare.api.dto.babyaction.sleep;

import com.bitechular.babycare.api.dto.babyaction.ActionUpdateRequest;

public class SleepActionUpdateRequest extends ActionUpdateRequest {
    public boolean night;

    public boolean isNight() {
        return night;
    }

    public void setNight(boolean night) {
        this.night = night;
    }
}
