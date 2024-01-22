package com.bitechular.babycare.data.model;

import com.bitechular.babycare.data.core.DomainEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;

@Entity
public class AuthSession extends DomainEntity {
    @ManyToOne(optional = false)
    public User user;
    public String token;
    public String clientId;
    public String notificationId;

    public AuthSession(User user, String token) {
        this.user = user;
        this.token = token;
        this.clientId = token.substring(token.length() - 8);
    }

    public AuthSession() {
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }
}
