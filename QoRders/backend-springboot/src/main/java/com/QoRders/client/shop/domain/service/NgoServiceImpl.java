package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.assembler.NgoAssembler;
import com.QoRders.client.shop.api.dto.NgoDto;
import com.QoRders.client.shop.domain.entity.NgoEntity;
import com.QoRders.client.shop.domain.repository.NgoRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class NgoServiceImpl implements NgoService {

    private final NgoRepository ngoRepository;
    private final NgoAssembler ngoAssembler;

    public NgoServiceImpl(NgoRepository ngoRepository, NgoAssembler ngoAssembler) {
        this.ngoRepository = ngoRepository;
        this.ngoAssembler = ngoAssembler;
    }

    @Override
    public List<NgoDto> listAll() {
        List<NgoEntity> ngos = ngoRepository.findAll();
        return ngos.stream()
                .map(ngoAssembler::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<NgoDto> listOneBySlug(String slug) {
        return ngoRepository.findByNgoSlug(slug)
                .map(ngoAssembler::toDto);
    }
}