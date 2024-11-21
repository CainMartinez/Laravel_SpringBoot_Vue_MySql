package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.dto.NgoDto;

import java.util.List;
import java.util.Optional;

public interface NgoService {
    List<NgoDto> listAll();
    Optional<NgoDto> listOneBySlug(String slug);
}