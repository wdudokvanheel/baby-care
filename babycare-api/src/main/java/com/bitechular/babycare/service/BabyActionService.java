package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.BabyActionRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class BabyActionService {
    private BabyActionRepository repository;

    public BabyActionService(BabyActionRepository repository) {
        this.repository = repository;
    }

    public BabyAction save(BabyAction action) {
        return repository.save(action);
    }

    public BabyAction getById(long id) throws EntityNotFoundException {
        return repository.findById(id).orElseThrow(() -> new EntityNotFoundException("BabyAction", id));
    }

    public List<BabyAction> getNewActionsForClient(AuthSession session, Date from, int limit) {
        return repository.findUpdatedActionsForUser(from, session, Pageable.ofSize(10));
    }
}
