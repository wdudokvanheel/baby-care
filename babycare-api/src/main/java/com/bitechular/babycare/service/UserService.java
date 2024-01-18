package com.bitechular.babycare.service;

import com.bitechular.babycare.data.dao.UserRepository;
import com.bitechular.babycare.data.model.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    private UserRepository repository;
    private PasswordEncoder passwordEncoder;

    public UserService(UserRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<User> getByEmail(String email) {
        return repository.findByEmail(email);
    }

    public User getOrCreateGoogleUserByEmail(String email) {
        return getByEmail(email).orElseGet(() -> {
            User newUser = new User();
            newUser.setActive(true);
            newUser.setEmail(email);
            save(newUser);
            return newUser;
        });
    }

    public boolean doesUserExistWithEmail(String email) {
        return repository.existsByEmail(email);
    }

    public User save(User user) {
        return repository.save(user);
    }

    public void setPassword(User user, String password) {
        user.setPassword(passwordEncoder.encode(password));
    }
}
