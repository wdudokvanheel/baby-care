package com.bitechular.babycare.api.controller;

import com.bitechular.babycare.api.dto.babyaction.*;
import com.bitechular.babycare.api.mapper.BabyActionMapper;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.Baby;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.service.BabyActionService;
import com.bitechular.babycare.service.BabyService;
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
@RequestMapping("/api/baby/{babyId}/")
public class BabyActionController {
    private final Logger logger = LoggerFactory.getLogger(BabyActionController.class);

    private BabyActionService actionService;
    private BabyActionMapper mapper;
    private PushNotificationService notificationService;
    private BabyService babyService;

    public BabyActionController(BabyActionService actionService, BabyActionMapper mapper, PushNotificationService notificationService, BabyService babyService) {
        this.actionService = actionService;
        this.mapper = mapper;
        this.notificationService = notificationService;
        this.babyService = babyService;
    }

    @PostMapping("action/*")
    public ResponseEntity<BabyActionDto> saveAction(@RequestBody BabyActionCreateRequest request, @PathVariable long babyId, @AuthenticationPrincipal AuthSession session) throws EntityNotFoundException {
        Baby baby = babyService.getBabyByUser(session.getUser(), babyId);

        BabyAction action = mapper.fromCreateDto(request);
        action.setBaby(baby);
        action.setLastModifiedBy(session);
        action = actionService.save(action);

        BabyActionDto dto = mapper.toDto(action);
        notificationService.notifyClientsOfUpdate(session, dto);
        return ResponseEntity.ok(dto);
    }

    @PutMapping("action/{id}/")
    public ResponseEntity<BabyActionDto> updateAction(@PathVariable Long id, @PathVariable long babyId, @RequestBody BabyActionUpdateRequest request, @AuthenticationPrincipal AuthSession session) throws EntityNotFoundException {
        Baby baby = babyService.getBabyByUser(session.getUser(), babyId);

        BabyAction action = actionService.getById(id);
        if (action.baby != baby) {
            // TODO Improve error reporting
            throw new EntityNotFoundException("Action", id);
        }

        action = mapper.fromUpdateDto(action, request);
        action.setLastModifiedBy(session);
        action = actionService.save(action);

        BabyActionDto dto = mapper.toDto(action);
        notificationService.notifyClientsOfUpdate(session, dto);

        return ResponseEntity.ok(dto);
    }

    @PostMapping("sync")
    public ResponseEntity<SyncResponse> syncActions(@RequestBody SyncRequest request, @PathVariable long babyId, @AuthenticationPrincipal AuthSession session) throws EntityNotFoundException {
        logger.debug("Request sync from: {}", request.from);
        Baby baby = babyService.getBabyByUser(session.getUser(), babyId);

        // Get list of baby actions for this user starting from date request.from
        List<BabyAction> actions = actionService.getNewBabyActionsForClient(session, baby, request.from, 10);
        List<BabyActionDto> dtos = actions
                .stream()
                .map(action -> mapper.toDto(action))
                .collect(Collectors.toList());

        Date syncedUntil = request.from;
        if (actions.size() > 0) {
            syncedUntil = actions.getLast().getModified();
        }

        return ResponseEntity.ok(new SyncResponse(dtos, syncedUntil));
    }
}
