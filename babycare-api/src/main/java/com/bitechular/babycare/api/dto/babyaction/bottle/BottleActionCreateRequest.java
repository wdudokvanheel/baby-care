package com.bitechular.babycare.api.dto.babyaction.bottle;

import com.bitechular.babycare.api.dto.babyaction.ActionCreateRequest;

public class BottleActionCreateRequest extends ActionCreateRequest {
    public int quantity;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
