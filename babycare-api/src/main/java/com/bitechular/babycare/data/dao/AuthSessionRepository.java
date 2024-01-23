package com.bitechular.babycare.data.dao;

import com.bitechular.babycare.data.core.DomainRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AuthSessionRepository extends DomainRepository<AuthSession> {
    Optional<AuthSession> findAuthSessionByUserAndToken(User user, String token);
    List<AuthSession> findAuthSessionsByTokenNotAndNotificationIdNotNull(String token);
    List<AuthSession> deleteAuthSessionByUserAndDeviceId(User user, String id);
}
