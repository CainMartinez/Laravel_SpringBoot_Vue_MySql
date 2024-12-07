package com.QoRders.client.shop.domain.service;

import com.QoRders.client.redis.RedisService;
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
    private final RedisService redisService;

    private static final long NGO_CACHE_TTL = 21600; // 6 hours in seconds

    public NgoServiceImpl(NgoRepository ngoRepository, NgoAssembler ngoAssembler, RedisService redisService) {
        this.ngoRepository = ngoRepository;
        this.ngoAssembler = ngoAssembler;
        this.redisService = redisService;
    }

    @Override
    public List<NgoDto> listAll() {
        String redisKey = "ngo:listAll";

        // Intentar obtener la lista desde Redis
        @SuppressWarnings("unchecked")
        List<NgoDto> cachedNgos = (List<NgoDto>) redisService.get(redisKey);
        if (cachedNgos != null) {
            return cachedNgos;
        }

        // Si no está en Redis, buscar en la base de datos
        List<NgoEntity> ngos = ngoRepository.findAll();
        List<NgoDto> ngoDtos = ngos.stream()
                .map(ngoAssembler::toDto)
                .collect(Collectors.toList());

        // Guardar la lista en Redis con TTL
        redisService.save(redisKey, ngoDtos, NGO_CACHE_TTL);

        return ngoDtos;
    }

    @Override
    public Optional<NgoDto> listOneBySlug(String slug) {
        String redisKey = "ngo:slug:" + slug;

        // Intentar obtener la ONG desde Redis
        NgoDto cachedNgo = (NgoDto) redisService.get(redisKey);
        if (cachedNgo != null) {
            return Optional.of(cachedNgo);
        }

        // Si no está en Redis, buscar en la base de datos
        Optional<NgoDto> ngoDto = ngoRepository.findByNgoSlug(slug)
                .map(ngoAssembler::toDto);

        ngoDto.ifPresent(ngo -> {
            // Guardar en Redis con TTL
            redisService.save(redisKey, ngo, NGO_CACHE_TTL);
        });

        return ngoDto;
    }
}