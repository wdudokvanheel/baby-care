package com.bitechular.babycare.api.dto.babyaction;

public class BottleActionCreateRequest extends ActionCreateRequest {
    public int quantity;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
