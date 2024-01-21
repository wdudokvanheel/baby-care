package com.bitechular.babycare.data.dao;

import com.bitechular.babycare.data.core.DomainRepository;
import com.bitechular.babycare.data.model.BabyAction;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface BabyActionRepository extends DomainRepository<BabyAction> {
    @Query("SELECT b FROM BabyAction b WHERE b.modified > :afterDate AND b.lastModifiedBy <> :clientId ORDER BY b.start ASC")
    List<BabyAction> findActionsAfterDateExcludingClient(
            @Param("afterDate") Date afterDate,
            @Param("clientId") String clientId,
            Pageable pageable);
}
