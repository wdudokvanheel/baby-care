package com.bitechular.babycare.data.dao;

import com.bitechular.babycare.data.core.DomainRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.Baby;
import com.bitechular.babycare.data.model.BabyAction;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface BabyActionRepository extends DomainRepository<BabyAction> {
    @Query("SELECT ac FROM BabyAction ac, UserBaby ub, Baby ba WHERE ub.user = :#{#auth.user} AND ub.baby = ba AND ac.baby = ub.baby AND ac.modified > :date AND (ac.lastModifiedBy != :auth OR ac.lastModifiedBy IS NULL)")
    List<BabyAction> findUpdatedActionsForUser(@Param("date") Date date, @Param("auth") AuthSession authSession, Pageable pageable);

    @Query("SELECT ac FROM BabyAction ac, UserBaby ub, Baby ba WHERE ba.id = :#{#baby.id} AND ub.user = :#{#auth.user} AND ub.baby = ba AND ac.baby = ub.baby AND ac.modified > :date AND (ac.lastModifiedBy != :auth OR ac.lastModifiedBy IS NULL)")
    List<BabyAction> findUpdatedActionsForUser(@Param("date") Date date, @Param("auth") AuthSession authSession, @Param("baby") Baby baby, Pageable pageable);
}
