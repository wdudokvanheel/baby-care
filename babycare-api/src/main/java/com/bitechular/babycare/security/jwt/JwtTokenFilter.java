package com.bitechular.babycare.security.jwt;


import com.bitechular.babycare.security.AuthenticationService;
import com.bitechular.babycare.security.UserAuthentication;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

public class JwtTokenFilter extends OncePerRequestFilter {
    private JwtTokenService jwtTokenService;
    private AuthenticationService authenticationService;

    public JwtTokenFilter(JwtTokenService jwtTokenService, AuthenticationService authenticationService) {
        this.jwtTokenService = jwtTokenService;
        this.authenticationService = authenticationService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, FilterChain filterChain) throws ServletException, IOException {
        SecurityContextHolder.clearContext();

        String token = jwtTokenService.resolveToken(httpServletRequest);
        if (token != null && jwtTokenService.validateToken(token)) {
            try {
                UserAuthentication authentication = authenticationService.getAuthenticationByToken(token);
                SecurityContextHolder.getContext().setAuthentication(authentication);

            } catch (Exception e) {
            }
        }

        filterChain.doFilter(httpServletRequest, httpServletResponse);
    }
}
