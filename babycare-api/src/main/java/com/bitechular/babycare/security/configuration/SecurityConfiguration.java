package com.bitechular.babycare.security.configuration;

import com.bitechular.babycare.security.AuthenticationService;
import com.bitechular.babycare.security.jwt.JwtTokenFilter;
import com.bitechular.babycare.security.jwt.JwtTokenService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.Http403ForbiddenEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(
        securedEnabled = true,
        jsr250Enabled = true,
        prePostEnabled = true)
public class SecurityConfiguration {
    private JwtTokenService tokenService;
    private AuthenticationService authenticationService;

    public SecurityConfiguration(JwtTokenService tokenService, AuthenticationService authenticationService) {
        this.tokenService = tokenService;
        this.authenticationService = authenticationService;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http.csrf(AbstractHttpConfigurer::disable)
                .cors(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> {
                    session.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
                })
                .authorizeHttpRequests(request -> {
                    request.requestMatchers("/api/auth/**").anonymous();
                    request.requestMatchers("/api/**").authenticated();
//                    request.requestMatchers("/api/action").permitAll().anyRequest().authenticated();

//                    request.requestMatchers("/api/auth").permitAll();
//                    request.requestMatchers("/api/").permitAll();
                })
                .addFilterBefore(new JwtTokenFilter(tokenService, authenticationService), UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling(handler -> {
                    handler.authenticationEntryPoint(new Http403ForbiddenEntryPoint());
                })
                .build();


//        return http.cors().and().csrf().disable()
//                .exceptionHandling()
//                .authenticationEntryPoint(new Http403ForbiddenEntryPoint())
//                .and()
//                .sessionManagement()
//                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
//                .and().authorizeRequests()
//                .requestMatchers("/public/**").permitAll()
//                .requestMatchers("/private/**").authenticated()
//                .and().apply(jwtFilterConfigurer)
//                .and().build();
    }


}
