package com.bitechular.babycare.data.model;

import com.bitechular.babycare.data.core.DomainEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

import java.util.Date;
import java.util.List;

@Entity
public class Baby extends DomainEntity {
    @OneToMany(mappedBy = "baby")
    private List<UserBaby> owners;

    private String name;
    private Date birthdate;
    @ManyToOne
    private AuthSession lastModifiedBy;

    public List<UserBaby> getOwners() {
        return owners;
    }

    public void setOwners(List<UserBaby> owners) {
        this.owners = owners;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(Date birthdate) {
        this.birthdate = birthdate;
    }

    public AuthSession getLastModifiedBy() {
        return lastModifiedBy;
    }

    public void setLastModifiedBy(AuthSession lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
    }
}
