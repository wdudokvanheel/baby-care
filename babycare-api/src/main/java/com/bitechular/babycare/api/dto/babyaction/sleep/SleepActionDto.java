package com.bitechular.babycare.api.dto.babyaction.sleep;

import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;

public class SleepActionDto extends BabyActionDto {
    public boolean night;

    public boolean isNight() {
        return night;
    }

    public void setNight(boolean night) {
        this.night = night;
    }
}
