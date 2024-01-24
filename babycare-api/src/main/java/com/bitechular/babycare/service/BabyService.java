package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.BabyRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.Baby;
import com.bitechular.babycare.data.model.User;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
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

    public Baby getBabyByUser(User user, long babyId) throws EntityNotFoundException {
        return repository.findBabyByIdAndUser(babyId, user).orElseThrow(() -> new EntityNotFoundException("Baby", babyId));
    }
}
