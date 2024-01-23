package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.BabyRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.Baby;
import com.bitechular.babycare.data.model.User;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class BabyService {
    private BabyRepository repository;

    public BabyService(BabyRepository repository) {
        this.repository = repository;
    }

    public List<Baby> getAllBabies(User user) {
        return repository.findAllBabiesByUser(user);
    }

    public List<Baby> getNewBabiesForClient(AuthSession session, Date from, int limit) {
        return repository.findUpdatedBabiesForUser(from, session, Pageable.ofSize(limit));
    }
}
