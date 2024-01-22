package com.bitechular.babycare.api.controller;

import com.bitechular.babycare.api.dto.*;
import com.bitechular.babycare.api.mapper.BabyActionMapper;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.service.BabyActionService;
import com.bitechular.babycare.service.PushNotificationService;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/action")
public class BabyActionController {
    private final Logger logger = LoggerFactory.getLogger(BabyActionController.class);

    private BabyActionService service;
    private BabyActionMapper mapper;
    private PushNotificationService notificationService;

    public BabyActionController(BabyActionService service, BabyActionMapper mapper, PushNotificationService notificationService) {
        this.service = service;
        this.mapper = mapper;
        this.notificationService = notificationService;
    }

    @PostMapping("*")
    public ResponseEntity<BabyActionDto> saveAction(@RequestBody BabyActionCreateRequestDto request, @AuthenticationPrincipal AuthSession session) {
        BabyAction action = mapper.fromCreateDto(request);
        action.lastModifiedBy = session.clientId;
        action = service.save(action);

        BabyActionDto dto = mapper.toDto(action);
        notificationService.notifyClientsOfUpdate(session, dto);
        return ResponseEntity.ok(dto);
    }

    @PutMapping("{id}/")
    public ResponseEntity<BabyActionDto> updateAction(@PathVariable Long id, @RequestBody BabyActionUpdateRequestDto request, @AuthenticationPrincipal AuthSession session) throws EntityNotFoundException {
        BabyAction action = service.getById(id);
        action = mapper.fromUpdateDto(action, request);
        action.lastModifiedBy = session.clientId;
        action = service.save(action);

        BabyActionDto dto = mapper.toDto(action);
        notificationService.notifyClientsOfUpdate(session, dto);

        return ResponseEntity.ok(dto);
    }

    @PostMapping("sync")
    public ResponseEntity<BabyActionSyncResponse> syncActions(@RequestBody BabyActionSyncRequest request, @AuthenticationPrincipal AuthSession session) {
        logger.debug("Request sync from: {}", request.from);
        // Get list of baby actions for this user starting from date request.from
        List<BabyAction> actions = service.getNewActionsForClient(session, request.from, 10);
        List<BabyActionDto> dtos = actions
                .stream()
                .map(action -> mapper.toDto(action))
                .collect(Collectors.toList());

        Date syncedUntil = request.from;
        if (actions.size() > 0) {
            syncedUntil = actions.getLast().getModified();
        }

        return ResponseEntity.ok(new BabyActionSyncResponse(dtos, syncedUntil));
    }
}
