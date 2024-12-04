package com.QoRders.client.auth.api.security.config;

import com.QoRders.client.auth.api.security.ratelimit.RateLimitFilter;
import jakarta.servlet.Filter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FilterConfig {

    @Bean(name = "customRateLimitFilter")
    public FilterRegistrationBean<Filter> rateLimitFilter(RateLimitFilter rateLimitFilter) {
        FilterRegistrationBean<Filter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(rateLimitFilter);
        registrationBean.addUrlPatterns("/api/auth/register"); // Limitar solo el endpoint /register
        registrationBean.setOrder(1); // Prioridad alta para este filtro
        return registrationBean;
    }
}