package com.bitechular.babycare.data.core;

import org.springframework.data.jpa.repository.JpaRepository;

public interface DomainRepository<T extends DomainEntity> extends JpaRepository<T, Long> {
}
