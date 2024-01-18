package com.bitechular.babycare.security.controller;

import java.util.StringJoiner;

public class EmailAuthenticationRequest {
    private String email;
    private String password;

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

    @Override
    public String toString() {
        return new StringJoiner(", ", EmailAuthenticationRequest.class.getSimpleName() + "[", "]")
                .add("email='" + email + "'")
                .add("password='" + password + "'")
                .toString();
    }
}
