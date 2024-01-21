package com.bitechular.babycare.security.controller;


import com.bitechular.babycare.data.model.User;
import com.bitechular.babycare.security.AuthenticationDetails;
import com.bitechular.babycare.security.AuthenticationService;
import com.bitechular.babycare.security.exception.InactiveUserException;
import com.bitechular.babycare.security.exception.InvalidCredentialsException;
import com.bitechular.babycare.security.exception.UserNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class UsernameAuthenticationController {
    private AuthenticationService authenticationService;

    public UsernameAuthenticationController(AuthenticationService authenticationService) {
        this.authenticationService = authenticationService;
    }

    @PostMapping("/api/auth/*")
    public ResponseEntity<AuthenticationDetails> authenticateUser(@RequestBody EmailAuthenticationRequest request) throws UserNotFoundException, InactiveUserException, InvalidCredentialsException {
        User user = authenticationService.authenticateUser(request.getEmail(), request.getPassword());
        AuthenticationDetails details = authenticationService.createAuthenticationDetails(user);
        // TODO Do something with the token here

        return ResponseEntity.ok(details);
    }

    @ExceptionHandler({InvalidCredentialsException.class, UserNotFoundException.class})
    @ResponseBody
    public ResponseEntity<AuthenticationFailedResponse> handleAuthenticationExceptions(Exception exception) {
        return ResponseEntity.status(403).body(new AuthenticationFailedResponse("invalid_credentials"));
    }
}
