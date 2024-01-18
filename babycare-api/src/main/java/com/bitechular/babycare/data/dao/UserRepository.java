package com.bitechular.babycare.data.dao;

import com.bitechular.babycare.data.core.DomainRepository;
import com.bitechular.babycare.data.model.User;

import java.util.Optional;

public interface UserRepository extends DomainRepository<User> {
    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);
}
