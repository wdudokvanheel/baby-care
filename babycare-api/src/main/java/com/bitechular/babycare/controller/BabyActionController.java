package com.bitechular.babycare.controller;

import com.bitechular.babycare.controller.dto.BabyActionCreateDto;
import com.bitechular.babycare.controller.dto.BabyActionUpdateDto;
import com.bitechular.babycare.controller.dto.mapper.BabyActionMapper;
import com.bitechular.babycare.data.model.BabyAction;
import com.bitechular.babycare.service.BabyActionService;
import com.bitechular.babycare.service.exception.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<BabyAction> saveAction(@RequestBody BabyActionCreateDto dto) {
        BabyAction action = mapper.fromCreateDto(dto);
        action = service.save(action);

        return ResponseEntity.ok(action);
    }

    @PutMapping("{id}/")
    public ResponseEntity<BabyAction> updateAction(@PathVariable Long id, @RequestBody BabyActionUpdateDto dto) throws EntityNotFoundException {
        BabyAction action = service.getById(id);
        action = mapper.fromUpdateDto(action, dto);
        action = service.save(action);
        return ResponseEntity.ok(action);
    }
}
