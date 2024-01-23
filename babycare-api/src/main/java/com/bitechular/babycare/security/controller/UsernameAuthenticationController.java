package com.bitechular.babycare.security.controller;


import com.bitechular.babycare.data.model.User;
import com.bitechular.babycare.security.AuthenticationDetails;
import com.bitechular.babycare.security.AuthenticationService;
import com.bitechular.babycare.security.exception.InactiveUserException;
import com.bitechular.babycare.security.exception.InvalidCredentialsException;
import com.bitechular.babycare.security.exception.UserNotFoundException;
import com.bitechular.babycare.service.PushNotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class UsernameAuthenticationController {
    private Logger logger = LoggerFactory.getLogger(UsernameAuthenticationController.class);

    private AuthenticationService authenticationService;
    private PushNotificationService pushNotificationService;

    public UsernameAuthenticationController(AuthenticationService authenticationService, PushNotificationService pushNotificationService) {
        this.authenticationService = authenticationService;
        this.pushNotificationService = pushNotificationService;
    }

    @PostMapping("/api/auth/*")
    public ResponseEntity<AuthenticationDetails> authenticateUser(@RequestBody EmailAuthenticationRequest request) throws UserNotFoundException, InactiveUserException, InvalidCredentialsException {
        User user = authenticationService.authenticateUser(request.getEmail(), request.getPassword());
        AuthenticationDetails details = authenticationService.createNewSession(user, request.getDeviceId());
        logger.info("{} authenticated for device: {}", user.getEmail(), request.getDeviceId());
        return ResponseEntity.ok(details);
    }

    @ExceptionHandler({InvalidCredentialsException.class, UserNotFoundException.class})
    @ResponseBody
    public ResponseEntity<AuthenticationFailedResponse> handleAuthenticationExceptions(Exception exception) {
        return ResponseEntity.status(403).body(new AuthenticationFailedResponse("invalid_credentials"));
    }
}
