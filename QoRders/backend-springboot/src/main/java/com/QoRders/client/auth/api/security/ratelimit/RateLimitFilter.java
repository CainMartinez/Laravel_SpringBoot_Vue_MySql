package com.QoRders.client.auth.api.security.ratelimit;

import io.github.bucket4j.Bucket;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class RateLimitFilter implements Filter {

    private final RateLimitConfig rateLimitConfig;

    public RateLimitFilter(RateLimitConfig rateLimitConfig) {
        this.rateLimitConfig = rateLimitConfig;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, jakarta.servlet.ServletException {
        if (request instanceof HttpServletRequest httpServletRequest) {
            String ipAddress = httpServletRequest.getRemoteAddr();
            Bucket bucket = rateLimitConfig.resolveBucket(ipAddress);

            if (!bucket.tryConsume(1)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"error\": \"Too many requests. Please try again later.\"}");
                ((jakarta.servlet.http.HttpServletResponse) response).setStatus(429); // HTTP 429 Too Many Requests
                return;
            }
        }

        chain.doFilter(request, response);
    }
}