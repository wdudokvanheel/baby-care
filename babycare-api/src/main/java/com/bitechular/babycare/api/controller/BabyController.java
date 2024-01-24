package com.bitechular.babycare.api.controller;

import com.bitechular.babycare.api.dto.baby.BabyDto;
import com.bitechular.babycare.api.dto.babyaction.SyncRequest;
import com.bitechular.babycare.api.dto.babyaction.SyncResponse;
import com.bitechular.babycare.api.mapper.BabyMapper;
import com.bitechular.babycare.data.model.AuthSession;
import com.bitechular.babycare.data.model.Baby;
import com.bitechular.babycare.service.BabyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/baby/")
public class BabyController {
    private Logger logger = LoggerFactory.getLogger(BabyController.class);

    private BabyService service;
    private BabyMapper mapper;

    public BabyController(BabyService babyService, BabyMapper mapper) {
        this.service = babyService;
        this.mapper = mapper;
    }

    @GetMapping("*")
    public ResponseEntity<List<BabyDto>> getAllBabies(@AuthenticationPrincipal AuthSession session) {
        List<BabyDto> babies = service
                .getAllBabies(session.getUser())
                .stream()
                .map(baby -> mapper.toDto(baby))
                .collect(Collectors.toList());

        return ResponseEntity.ok(babies);
    }

    @PostMapping("sync")
    public ResponseEntity<SyncResponse<BabyDto>> syncBabies(@RequestBody SyncRequest request, @AuthenticationPrincipal AuthSession session) {
        logger.debug("Request baby sync from: {}", request.from);
        // Get list of baby actions for this user starting from date request.from
        List<Baby> babies = service.getNewBabiesForClient(session, request.from, 256);
        logger.info("Found {} babies for {}", babies.size(), session.getUser().getEmail());
        List<BabyDto> dtos = babies
                .stream()
                .map(action -> mapper.toDto(action))
                .collect(Collectors.toList());

        Date syncedUntil = request.from;
        if (babies.size() > 0) {
            syncedUntil = babies.getLast().getModified();
        }

        return ResponseEntity.ok(new SyncResponse(dtos, syncedUntil));
    }
}
