package com.bitechular.babycare.api.controller;

import com.bitechular.babycare.api.dto.BabyActionCreateRequestDto;
import com.bitechular.babycare.api.dto.BabyActionDto;
import com.bitechular.babycare.api.dto.BabyActionUpdateRequestDto;
import com.bitechular.babycare.api.mapper.BabyActionMapper;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.security.UserSession;
import com.bitechular.babycare.service.BabyActionService;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/action")
public class BabyActionController {
    private final Logger logger = LoggerFactory.getLogger(BabyActionController.class);

    private BabyActionService service;
    private BabyActionMapper mapper;

    public BabyActionController(BabyActionService service, BabyActionMapper mapper) {
        this.service = service;
        this.mapper = mapper;
    }

    @PostMapping("*")
    public ResponseEntity<BabyActionDto> saveAction(@RequestBody BabyActionCreateRequestDto dto, @AuthenticationPrincipal UserSession session) {
        BabyAction action = mapper.fromCreateDto(dto);
        action.lastModifiedBy = session.clientId;
        action = service.save(action);
        return ResponseEntity.ok(mapper.toDto(action));
    }

    @PutMapping("{id}/")
    public ResponseEntity<BabyActionDto> updateAction(@PathVariable Long id, @RequestBody BabyActionUpdateRequestDto dto, @AuthenticationPrincipal UserSession session) throws EntityNotFoundException {
        BabyAction action = service.getById(id);
        action = mapper.fromUpdateDto(action, dto);
        action.lastModifiedBy = session.clientId;
        action = service.save(action);
        return ResponseEntity.ok(mapper.toDto(action));
    }
}
