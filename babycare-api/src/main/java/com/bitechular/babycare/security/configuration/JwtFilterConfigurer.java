package com.bitechular.babycare.security.configuration;

import com.bitechular.babycare.security.AuthenticationService;
import com.bitechular.babycare.security.jwt.JwtTokenFilter;
import com.bitechular.babycare.security.jwt.JwtTokenService;
import org.springframework.security.config.annotation.SecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Service;

//@Service
//public class JwtFilterConfigurer extends SecurityConfigurerAdapter<DefaultSecurityFilterChain, HttpSecurity> {
//    private JwtTokenService jwtTokenService;
//    private AuthenticationService authenticationService;
//
//    public JwtFilterConfigurer(JwtTokenService jwtTokenService, AuthenticationService authenticationService) {
//        this.jwtTokenService = jwtTokenService;
//        this.authenticationService = authenticationService;
//    }
//
//    @Override
//    public void configure(HttpSecurity http) throws Exception {
//        JwtTokenFilter customFilter = new JwtTokenFilter(jwtTokenService, authenticationService);
//        http.addFilterBefore(customFilter, UsernamePasswordAuthenticationFilter.class);
//    }
//}
