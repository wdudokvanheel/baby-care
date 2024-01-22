package com.bitechular.babycare.api.controller;

import com.bitechular.babycare.api.dto.NotificationRegistrationRequest;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.service.AuthSessionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/notifications/")
public class NotificationRegistrationController {
    private Logger logger = LoggerFactory.getLogger(NotificationRegistrationController.class);

    private AuthSessionService authService;

    public NotificationRegistrationController(AuthSessionService authService) {
        this.authService = authService;
    }

    @PostMapping("register")
    public ResponseEntity register(@RequestBody NotificationRegistrationRequest request, @AuthenticationPrincipal AuthSession session) {
        authService.registerNotifications(session, request.clientId);
        logger.debug("Registered device id {} to {}", request.clientId, session.getUser().getEmail());
        return ResponseEntity.ok().build();
    }
}
