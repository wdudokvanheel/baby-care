package com.bitechular.babycare.security.exception;

public class InvalidSessionException extends Exception {
    public InvalidSessionException() {
        super("Invalid session");
    }
}
