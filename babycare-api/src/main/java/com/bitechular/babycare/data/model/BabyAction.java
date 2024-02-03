package com.bitechular.babycare.data.model;

import com.bitechular.babycare.data.core.DomainEntity;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Table(name = "BabyAction")
public class BabyAction extends DomainEntity {
    @ManyToOne(optional = false)
    public Baby baby;

    @Enumerated(EnumType.STRING)
    private BabyActionType type;

    @Basic(optional = false)
    private boolean deleted = false;

    private Date start;
    private Date end;

    @ManyToOne
    private AuthSession lastModifiedBy;

    public Baby getBaby() {
        return baby;
    }

    public void setBaby(Baby baby) {
        this.baby = baby;
    }

    public BabyActionType getType() {
        return type;
    }

    public void setType(BabyActionType type) {
        this.type = type;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public AuthSession getLastModifiedBy() {
        return lastModifiedBy;
    }

    public void setLastModifiedBy(AuthSession lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
    }
}
