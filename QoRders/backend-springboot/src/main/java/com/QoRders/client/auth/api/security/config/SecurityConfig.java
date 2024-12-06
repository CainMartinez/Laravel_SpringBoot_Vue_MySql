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
    private final CustomAuthenticationEntryPoint customAuthenticationEntryPoint;

    @Bean
    public Argon2PasswordEncoder passwordEncoder() {
        // Configuración del algoritmo Argon2 para encriptación segura de contraseñas
        return new Argon2PasswordEncoder(16, 32, 1, 4096, 3);
    }
    @SuppressWarnings("deprecation")
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable()) // Deshabilitar CSRF
            .sessionManagement(session -> session
                .sessionCreationPolicy(org.springframework.security.config.http.SessionCreationPolicy.STATELESS)) // Política de sesión sin estado
            .authorizeRequests(auth -> auth
                .requestMatchers("/api/auth/register", "/api/auth/login").permitAll() // Endpoints públicos
                .requestMatchers("/api/client/**", "/api/auth/logout", "/api/auth/refresh").authenticated()) // Proteger otros endpoints
            .exceptionHandling(handling -> handling
                .authenticationEntryPoint(customAuthenticationEntryPoint)) // Manejo de errores de autenticación
            .addFilterBefore(
                new JwtAuthenticationFilter(jwtProvider, null, null), // Filtro JWT personalizado
                UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        // Configuración del AuthenticationManager
        return authenticationConfiguration.getAuthenticationManager();
    }
}