package com.bitechular.babycare.security.controller;

import java.util.StringJoiner;

public class EmailAuthenticationRequest {
    private String email;
    private String password;
    private String deviceId;

    public EmailAuthenticationRequest(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    @Override
    public String toString() {
        return new StringJoiner(", ", EmailAuthenticationRequest.class.getSimpleName() + "[", "]")
                .add("email='" + email + "'")
                .add("password='" + password + "'")
                .add("deviceId='" + deviceId + "'")
                .toString();
    }
}
