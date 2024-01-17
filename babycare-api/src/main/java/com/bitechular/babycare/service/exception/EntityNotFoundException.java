package com.bitechular.babycare.service.exception;

public class EntityNotFoundException extends Exception {
    public EntityNotFoundException(String name, Long id) {
        super(name + " #" + id + " not found");
    }
}
