package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.AuthSessionRepository;
import com.bitechular.babycare.data.model.AuthSession;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AuthSessionService {
    private AuthSessionRepository repository;

    public AuthSessionService(AuthSessionRepository repository) {
        this.repository = repository;
    }

    public List<String> getNotificationIdsForUpdate(AuthSession sender) {
        return repository.
                findAuthSessionsByTokenNotAndNotificationIdNotNull(sender.getToken())
                .stream()
                .map(session -> session.getNotificationId())
                .collect(Collectors.toList());
    }
}
