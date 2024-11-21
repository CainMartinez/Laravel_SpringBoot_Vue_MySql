package com.QoRders.client.shop.api.assembler;

import com.QoRders.client.shop.api.dto.NgoDto;
import com.QoRders.client.shop.api.response.NgoResponse;
import com.QoRders.client.shop.domain.entity.NgoEntity;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class NgoAssembler {

    public NgoResponse toResponse(NgoEntity ngo) {
        NgoResponse response = new NgoResponse();
        response.setUuid(ngo.getNgoUuid());
        response.setName(ngo.getNgoName());
        response.setSlug(ngo.getNgoSlug());
        response.setDescription(ngo.getDescription());
        response.setCountry(ngo.getCountry());
        response.setEmail(ngo.getEmail());
        response.setPhoneNumber(ngo.getPhoneNumber());
        response.setWebsiteUrl(ngo.getWebsiteUrl());
        response.setLogoUrl(ngo.getLogoUrl());
        response.setImageUrl(ngo.getImageUrl());
        response.setTotalDonations(ngo.getTotalDonations());
        return response;
    }

    public NgoDto toDto(NgoEntity ngo) {
        NgoDto dto = new NgoDto();
        dto.setUuid(ngo.getNgoUuid());
        dto.setName(ngo.getNgoName());
        dto.setSlug(ngo.getNgoSlug());
        dto.setDescription(ngo.getDescription());
        dto.setCountry(ngo.getCountry());
        dto.setEmail(ngo.getEmail());
        dto.setPhoneNumber(ngo.getPhoneNumber());
        dto.setWebsiteUrl(ngo.getWebsiteUrl());
        dto.setLogoUrl(ngo.getLogoUrl());
        dto.setImageUrl(ngo.getImageUrl());
        dto.setTotalDonations(ngo.getTotalDonations());
        return dto;
    }

    public List<NgoResponse> toResponseList(List<NgoEntity> ngos) {
        return ngos.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
}