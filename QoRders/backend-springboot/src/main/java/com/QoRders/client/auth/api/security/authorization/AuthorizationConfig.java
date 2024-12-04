package com.QoRders.client.auth.api.security.authorization;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import com.QoRders.client.client.domain.service.ClientService;

import lombok.RequiredArgsConstructor;

import java.util.Collection;

@Component
@RequiredArgsConstructor
public class AuthorizationConfig {

    @SuppressWarnings("unused")
    private final ClientService clientService;

    /**
     * Verifica si el usuario actual está autenticado.
     * 
     * @return true si el usuario está autenticado, false de lo contrario.
     */
    public boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.isAuthenticated();
    }

    /**
     * Verifica si el usuario autenticado tiene un rol específico.
     *
     * @param role el rol a verificar (por ejemplo, "ROLE_ADMIN", "ROLE_USER").
     * @return true si el usuario tiene el rol, false de lo contrario.
     */
    public boolean hasRole(String role) {
        if (!isAuthenticated()) {
            return false;
        }

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        return authorities.stream()
                .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals(role));
    }
}