package com.bitechular.babycare.security;

import com.bitechular.babycare.data.dao.AuthSessionRepository;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.User;
import com.bitechular.babycare.security.exception.InactiveUserException;
import com.bitechular.babycare.security.exception.InvalidCredentialsException;
import com.bitechular.babycare.security.exception.InvalidSessionException;
import com.bitechular.babycare.security.exception.UserNotFoundException;
import com.bitechular.babycare.security.jwt.JwtTokenService;
import com.bitechular.babycare.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthenticationService {
    private Logger logger = LoggerFactory.getLogger(AuthenticationService.class);

    private JwtTokenService tokenService;
    private UserService userService;
    private PasswordEncoder passwordEncoder;
    private AuthSessionRepository authRepo;

    public AuthenticationService(JwtTokenService tokenService, UserService userService, PasswordEncoder passwordEncoder, AuthSessionRepository authRepo) {
        this.tokenService = tokenService;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.authRepo = authRepo;
    }

    public User authenticateUser(String email, String password) throws UserNotFoundException, InactiveUserException, InvalidCredentialsException {
        User user = userService.getByEmail(email).orElseThrow(() -> new UserNotFoundException(email));

        validatePassword(user, password);
        validateUserActive(user);

        return user;
    }

    public void validateUserActive(User user) throws InactiveUserException {
        if (!user.isActive()) {
            throw new InactiveUserException();
        }
    }

    public void validatePassword(User user, String password) throws InvalidCredentialsException {
        if (password == null || user.getPassword() == null || !passwordEncoder.matches(password, user.getPassword())) {
            throw new InvalidCredentialsException();
        }
    }

    public UserAuthentication getAuthenticationByToken(String token) throws InactiveUserException, UserNotFoundException, InvalidSessionException {
        String email = tokenService.getEmailFromToken(token);
        User user = userService.getByEmail(email).orElseThrow(() -> new UserNotFoundException(email));

        if (user == null) {
            return null;
        }

        validateUserActive(user);
        AuthSession session = authRepo.findAuthSessionByUserAndToken(user, token).orElseThrow(() -> new InvalidSessionException());

        return new UserAuthentication(session);
    }

    public AuthenticationDetails createAuthenticationDetails(User user) {
        String token = tokenService.createToken(user.getEmail());
        AuthSession session = new AuthSession(user, token);
        authRepo.save(session);

        return new AuthenticationDetails(token, user.getEmail());
    }
}
