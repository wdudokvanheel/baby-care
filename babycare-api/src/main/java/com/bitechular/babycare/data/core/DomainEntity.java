package com.bitechular.babycare.data.core;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Date;

@MappedSuperclass
public abstract class DomainEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Date created;
    private Date modified;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreated() {
        return created;
    }

    public void onPersist(Date created) {
        this.created = created;
    }

    public Date getModified() {
        return modified;
    }

    @PrePersist
    public void onPersist() {
        created = new Date();
        modified = created;
    }

    @PreUpdate
    public void onUpdate() {
        modified = new Date();
    }
}
