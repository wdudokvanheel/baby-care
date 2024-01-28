package com.bitechular.babycare.data.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "BottleAction")
public class BottleAction extends BabyAction {
    private int quantity;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int ml) {
        this.quantity = ml;
    }
}
