package com.QoRders.client.auth.api.security.config;

import com.QoRders.client.auth.api.security.jwt.JwtAuthenticationFilter;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtProvider jwtProvider;

    @Bean
    public Argon2PasswordEncoder passwordEncoder() {
        // Configuración del algoritmo Argon2 para encriptación segura de contraseñas
        return new Argon2PasswordEncoder(16, 32, 1, 4096, 3);
    }

    @SuppressWarnings("deprecation")
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // Deshabilitar CSRF y configurar la política de sesión
        http.csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session
                .sessionCreationPolicy(org.springframework.security.config.http.SessionCreationPolicy.STATELESS))
            .authorizeRequests(auth -> auth
                .requestMatchers("/api/auth/register", "/api/auth/login").permitAll() // Endpoints públicos
                .requestMatchers("/api/client/**", "/api/auth/logout", "/api/auth/refresh").authenticated()) // Proteger otros endpoints
            .addFilterBefore(
                new JwtAuthenticationFilter(jwtProvider, null, null), 
                UsernamePasswordAuthenticationFilter.class // Insertar el filtro antes del estándar
            );

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        // Configuración del AuthenticationManager
        return authenticationConfiguration.getAuthenticationManager();
    }
}