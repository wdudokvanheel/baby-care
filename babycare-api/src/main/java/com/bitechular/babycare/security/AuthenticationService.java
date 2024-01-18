package com.bitechular.babycare.security;

import com.bitechular.babycare.data.model.User;
import com.bitechular.babycare.security.exception.InactiveUserException;
import com.bitechular.babycare.security.exception.InvalidCredentialsException;
import com.bitechular.babycare.security.exception.UserNotFoundException;
import com.bitechular.babycare.security.jwt.JwtTokenService;
import com.bitechular.babycare.service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthenticationService {
    private JwtTokenService tokenService;
    private UserService userService;
    private PasswordEncoder passwordEncoder;

    public AuthenticationService(JwtTokenService tokenService, UserService userService, PasswordEncoder passwordEncoder) {
        this.tokenService = tokenService;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
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

    public UserAuthentication getAuthenticationByToken(String token) throws InactiveUserException, UserNotFoundException {
        String email = tokenService.getEmailFromToken(token);
        User user = userService.getByEmail(email).orElseThrow(() -> new UserNotFoundException(email));

        if (user == null) {
            return null;
        }

        validateUserActive(user);

        return new UserAuthentication(user);
    }

    public AuthenticationDetails createAuthenticationDetails(User user) {
        return new AuthenticationDetails(tokenService.createToken(user.getEmail()), user.getEmail());
    }
}
