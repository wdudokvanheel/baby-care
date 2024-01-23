package com.bitechular.babycare.data.model;

import com.bitechular.babycare.data.core.DomainEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PreRemove;

import java.util.List;

@Entity
public class AuthSession extends DomainEntity {
    @ManyToOne(optional = false)
    private User user;
    private String token;
    private String deviceId;
    private String notificationId;

    @OneToMany(mappedBy = "lastModifiedBy")
    private List<Baby> lastUpdatedBabies;

    @OneToMany(mappedBy = "lastModifiedBy")
    private List<BabyAction> lastUpdatedActions;

    public AuthSession(User user, String token, String deviceId) {
        this.user = user;
        this.token = token;
        this.deviceId = deviceId;
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

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public List<Baby> getLastUpdatedBabies() {
        return lastUpdatedBabies;
    }

    public void setLastUpdatedBabies(List<Baby> lastUpdatedBabies) {
        this.lastUpdatedBabies = lastUpdatedBabies;
    }

    public List<BabyAction> getLastUpdatedActions() {
        return lastUpdatedActions;
    }

    public void setLastUpdatedActions(List<BabyAction> lastUpdatedActions) {
        this.lastUpdatedActions = lastUpdatedActions;
    }

    @PreRemove
    private void preRemove() {
        for (Baby baby : lastUpdatedBabies) {
            baby.setLastModifiedBy(null);
        }

        for (BabyAction action : lastUpdatedActions) {
            action.setLastModifiedBy(null);
        }
    }
}
