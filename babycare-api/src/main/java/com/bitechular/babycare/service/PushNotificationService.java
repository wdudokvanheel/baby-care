package com.bitechular.babycare.service;

import com.bitechular.babycare.api.dto.BabyActionDto;
import com.bitechular.babycare.data.model.AuthSession;
import com.eatthepath.pushy.apns.*;
import com.eatthepath.pushy.apns.auth.ApnsSigningKey;
import com.eatthepath.pushy.apns.util.ApnsPayloadBuilder;
import com.eatthepath.pushy.apns.util.SimpleApnsPayloadBuilder;
import com.eatthepath.pushy.apns.util.SimpleApnsPushNotification;
import com.eatthepath.pushy.apns.util.TokenUtil;
import com.eatthepath.pushy.apns.util.concurrent.PushNotificationFuture;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
public class PushNotificationService {
    private Logger logger = LoggerFactory.getLogger(PushNotificationService.class);

    private AuthSessionService sessionService;
    private ApnsClient apnsClient;
    private ObjectMapper mapper;

    public PushNotificationService(AuthSessionService sessionService, ObjectMapper mapper) throws IOException, NoSuchAlgorithmException, InvalidKeyException {
        this.sessionService = sessionService;
        this.mapper = mapper;

        apnsClient = new ApnsClientBuilder()
                .setApnsServer(ApnsClientBuilder.DEVELOPMENT_APNS_HOST)
                .setSigningKey(ApnsSigningKey.loadFromPkcs8File(new File(getClass().getClassLoader().getResource("key.p8").getFile()),
                        "L23NTUN6KV", "2RBVXWR25Z"))
                .build();
    }

    public void notifyClientsOfUpdate(AuthSession sender, BabyActionDto action) {
        try {
            String data = mapper.writeValueAsString(action);
            logger.debug("Sending notification data: {}", data);
            List<String> ids = sessionService.getNotificationIdsForUpdate(sender);

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

//        payloadBuilder.addCustomProperty("data", "UPDATE ACTION");
        payloadBuilder.addCustomProperty("data", data);

        String payload = payloadBuilder.build();
//        String token = TokenUtil.sanitizeTokenString("bef2cb5f16ccecb425b69e8c8cc2fec34e7c56043f76eae843cfdc541e2e3b53");
        String token = TokenUtil.sanitizeTokenString(to);

        SimpleApnsPushNotification pushNotification = new SimpleApnsPushNotification(token, "com.bitechular.tinybaby", payload, Instant.now().plus(90, ChronoUnit.MINUTES), DeliveryPriority.CONSERVE_POWER, PushType.BACKGROUND, null, null);
        PushNotificationFuture<SimpleApnsPushNotification, PushNotificationResponse<SimpleApnsPushNotification>> future = apnsClient.sendNotification(pushNotification);

        future.whenComplete((response, cause) -> {
            if (response != null) {
                // Handle the push notification response as before from here.
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
