package com.bitechular.babycare.data.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "SleepAction")
public class SleepAction extends BabyAction {
    private boolean night;

    public boolean isNight() {
        return night;
    }

    public void setNight(boolean night) {
        this.night = night;
    }
}
