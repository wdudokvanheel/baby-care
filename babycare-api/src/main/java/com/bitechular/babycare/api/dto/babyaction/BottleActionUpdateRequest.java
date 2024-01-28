package com.bitechular.babycare.api.dto.babyaction;

public class BottleActionUpdateRequest extends ActionUpdateRequest {
    public int quantity;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
