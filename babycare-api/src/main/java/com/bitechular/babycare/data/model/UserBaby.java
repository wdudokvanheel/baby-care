package com.bitechular.babycare.data.model;

import com.bitechular.babycare.data.core.DomainEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.ManyToOne;

@Entity
public class UserBaby extends DomainEntity {
    @ManyToOne(optional = false)
    private User user;
    @ManyToOne(optional = false)
    private Baby baby;
    @Enumerated(EnumType.STRING)
    private BabyPermissions permissions;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Baby getBaby() {
        return baby;
    }

    public void setBaby(Baby baby) {
        this.baby = baby;
    }

    public BabyPermissions getPermissions() {
        return permissions;
    }

    public void setPermissions(BabyPermissions permissions) {
        this.permissions = permissions;
    }
}

