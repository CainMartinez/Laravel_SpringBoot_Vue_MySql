package com.QoRders.client.auth.api.security.utils;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class AuthUtils {

    /**
     * Obtiene el correo electrónico del cliente autenticado.
     *
     * @return El correo electrónico del cliente autenticado.
     * @throws IllegalStateException si no hay un cliente autenticado.
     */
    public String getCurrentClientEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new IllegalStateException("No client is currently authenticated");
        }

        Object principal = authentication.getPrincipal();
        if (principal instanceof String) {
            return (String) principal; // El email se usa como principal
        }

        throw new IllegalStateException("Authentication principal is not a valid email");
    }

    /**
     * Verifica si el cliente actual está autenticado.
     *
     * @return true si el cliente está autenticado, false de lo contrario.
     */
    public boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.isAuthenticated();
    }

    /**
     * Verifica si el cliente autenticado tiene un rol específico.
     *
     * @param role El rol a verificar (e.g., "ROLE_CLIENT").
     * @return true si el cliente tiene el rol, false de lo contrario.
     */
    public boolean hasRole(String role) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }

        return authentication.getAuthorities().stream()
                .anyMatch(authority -> authority.getAuthority().equals(role));
    }
}