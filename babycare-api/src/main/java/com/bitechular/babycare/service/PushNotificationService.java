package com.bitechular.babycare.service;

import com.bitechular.babycare.api.dto.babyaction.BabyActionDto;
import com.bitechular.babycare.data.model.AuthSession;
import com.eatthepath.pushy.apns.*;
import com.eatthepath.pushy.apns.auth.ApnsSigningKey;
import com.eatthepath.pushy.apns.util.ApnsPayloadBuilder;
import com.eatthepath.pushy.apns.util.SimpleApnsPayloadBuilder;
import com.eatthepath.pushy.apns.util.SimpleApnsPushNotification;
import com.eatthepath.pushy.apns.util.TokenUtil;
import com.eatthepath.pushy.apns.util.concurrent.PushNotificationFuture;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
public class PushNotificationService {
    private Logger logger = LoggerFactory.getLogger(PushNotificationService.class);

    @Value("${babycare.notifications.push.enabled}")
    private Boolean enabled;
    @Value("${babycare.notifications.push.production}")
    private Boolean production;

    private AuthSessionService authService;
    private ApnsClient apnsClient;
    private ObjectMapper mapper;

    public PushNotificationService(AuthSessionService authService, ObjectMapper mapper) {
        this.authService = authService;
        this.mapper = mapper;
    }

    @PostConstruct
    public void init() throws IOException, NoSuchAlgorithmException, InvalidKeyException {
        if (!enabled) {
            logger.warn("Push notifications disabled");
        } else {
            logger.info("Starting Push notifications to " + (production ? "production" : "development") + " APNS host");
            Resource keyFile = new ClassPathResource("key.p8");
            String host = production ? ApnsClientBuilder.PRODUCTION_APNS_HOST : ApnsClientBuilder.DEVELOPMENT_APNS_HOST;

            apnsClient = new ApnsClientBuilder()
                    .setApnsServer(host)
                    .setSigningKey(ApnsSigningKey.loadFromInputStream(keyFile.getInputStream(), "L23NTUN6KV", "2RBVXWR25Z"))
                    .build();
        }
    }

    public void notifyClientsOfUpdate(AuthSession sender, BabyActionDto action) {
        if (!enabled) {
            return;
        }

        List<String> ids = authService.getNotificationIdsForUpdate(sender);
        if(ids.size() == 0){
            return;
        }

        try {
            String data = mapper.writeValueAsString(action);
            logger.debug("Sending notification data: {} to {} clients", data, ids.size());

            for (String id : ids) {
                logger.debug("\t To id: {}", id);
                sendNotification(id, data);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void sendNotification(String to, String data) {
        ApnsPayloadBuilder payloadBuilder = new SimpleApnsPayloadBuilder();
        payloadBuilder.setContentAvailable(true);

        payloadBuilder.addCustomProperty("data", data);

        String payload = payloadBuilder.build();
        String token = TokenUtil.sanitizeTokenString(to);

        SimpleApnsPushNotification pushNotification = new SimpleApnsPushNotification(token, "com.bitechular.tinybaby", payload, Instant.now().plus(90, ChronoUnit.MINUTES), DeliveryPriority.CONSERVE_POWER, PushType.BACKGROUND, null, null);
        PushNotificationFuture<SimpleApnsPushNotification, PushNotificationResponse<SimpleApnsPushNotification>> future = apnsClient.sendNotification(pushNotification);

        future.whenComplete((response, cause) -> {
            if (response != null) {
                // Handle the push notification response as before from here.
                if (!response.isAccepted()) {
                    logger.error("Notification denied: {}", response.getRejectionReason().orElse(""));
                    authService.invalidateNotificationId(to);
                }
                else{
                    logger.info("Send notification successful to {}: {}", to, response);
                }
            } else {
                // Something went wrong when trying to send the notification to the
                // APNs server. Note that this is distinct from a rejection from
                // the server, and indicates that something went wrong when actually
                // sending the notification or waiting for a reply.
                logger.error("Error sending notifcation: {}", cause);
            }
        });
    }
}
