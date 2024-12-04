package com.QoRders.client.auth.api.security.ratelimit;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Bucket4j;
import io.github.bucket4j.Refill;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Configuration
public class RateLimitConfig {

    private static final long LIMIT = 5; // Máximo de 5 solicitudes
    private static final Duration TIME_WINDOW = Duration.ofMinutes(1); // Cada 1 minuto

    private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    @Bean
    public Map<String, Bucket> rateLimitBuckets() {
        return buckets;
    }

    public Bucket resolveBucket(String key) {
        return buckets.computeIfAbsent(key, k -> createNewBucket());
    }

    private Bucket createNewBucket() {
        Bandwidth limit = Bandwidth.classic(LIMIT, Refill.greedy(LIMIT, TIME_WINDOW));
        return Bucket4j.builder().addLimit(limit).build(); // Cambiado a Bucket4j.builder()
    }
}