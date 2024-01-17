package com.bitechular.babycare.data.dao;

import com.bitechular.babycare.data.model.BabyAction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BabyActionDao extends JpaRepository<BabyAction, Long> {
}
