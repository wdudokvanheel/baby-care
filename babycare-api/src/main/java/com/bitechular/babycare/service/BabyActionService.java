package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.BabyActionRepository;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import org.springframework.stereotype.Service;

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
}
