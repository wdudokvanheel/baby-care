package com.bitechular.babycare.security.exception;

public class UserNotFoundException extends Exception{
    public UserNotFoundException(String user) {
        super("User not found: " + user);
    }
}
