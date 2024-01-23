package com.bitechular.babycare.data.dao;

import com.bitechular.babycare.data.core.DomainRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.Baby;
import com.bitechular.babycare.data.model.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface BabyRepository extends DomainRepository<Baby> {
    @Query("SELECT ub.baby FROM UserBaby ub WHERE ub.user = :user")
    List<Baby> findAllBabiesByUser(@Param("user") User user);

    @Query("SELECT ba FROM UserBaby ub, Baby ba WHERE ub.user = :#{#auth.user} AND ub.baby = ba AND ba.modified > :date AND (ba.lastModifiedBy != :auth OR ba.lastModifiedBy IS NULL)")
    List<Baby> findUpdatedBabiesForUser(@Param("date") Date date, @Param("auth") AuthSession authSession, Pageable pageable);
}
