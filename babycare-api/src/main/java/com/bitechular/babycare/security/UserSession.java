package com.bitechular.babycare.security;

import com.bitechular.babycare.data.model.User;

public class UserSession {
    public User user;
    public String token;
    public String clientId;

    public UserSession(User user, String token) {
        this.user = user;
        this.token = token;
        this.clientId = token.substring(token.length() - 8);
    }
}
