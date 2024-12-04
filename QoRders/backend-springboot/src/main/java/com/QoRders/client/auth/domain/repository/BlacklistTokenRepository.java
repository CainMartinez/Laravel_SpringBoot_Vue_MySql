package com.QoRders.client.auth.domain.repository;

import com.QoRders.client.auth.domain.entity.BlacklistTokenEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BlacklistTokenRepository extends JpaRepository<BlacklistTokenEntity, Long> {
    boolean existsByToken(String token);
}