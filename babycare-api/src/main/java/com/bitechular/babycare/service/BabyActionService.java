package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.BabyActionDao;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class BabyActionService {
    private BabyActionDao dao;

    public BabyActionService(BabyActionDao dao) {
        this.dao = dao;
    }

    public BabyAction save(BabyAction action) {
        if (action.id == null) {
            action.created = new Date();
        }
        action.modified = new Date();
        return dao.save(action);
    }

    public BabyAction getById(long id) throws EntityNotFoundException {
        return dao.findById(id).orElseThrow(() -> new EntityNotFoundException("BabyAction", id));
    }
}
