package com.bitechular.babycare.security;

public class AuthenticationDetails {
    private String token;
    private String email;

    public AuthenticationDetails(String token, String email) {
        this.token = token;
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public String getEmail() {
        return email;
    }
}
