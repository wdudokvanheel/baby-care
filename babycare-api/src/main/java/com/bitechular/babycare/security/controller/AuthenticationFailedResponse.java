package com.bitechular.babycare.security.controller;

public class AuthenticationFailedResponse {
    public String reason;

    public AuthenticationFailedResponse(String reason) {
        this.reason = reason;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
