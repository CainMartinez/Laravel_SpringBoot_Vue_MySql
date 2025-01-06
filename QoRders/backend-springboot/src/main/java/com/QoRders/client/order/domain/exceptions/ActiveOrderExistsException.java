package com.QoRders.client.order.domain.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

public class ActiveOrderExistsException extends ResponseStatusException {

    public ActiveOrderExistsException(String message) {
        super(HttpStatus.CONFLICT, message);
    }
}