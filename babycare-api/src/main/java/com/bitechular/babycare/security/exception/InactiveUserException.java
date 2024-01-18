package com.bitechular.babycare.security.exception;

public class InactiveUserException extends Exception{
    public InactiveUserException() {
        super("User's email is not verified");
    }
}
