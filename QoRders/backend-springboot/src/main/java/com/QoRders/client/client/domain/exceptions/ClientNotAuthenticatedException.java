package com.QoRders.client.client.domain.exceptions;

public class ClientNotAuthenticatedException extends RuntimeException {
    public ClientNotAuthenticatedException(String message) {
        super(message);
    }
}