package com.bitechular.babycare.security.jwt;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Base64;
import java.util.Date;

@Service
public class JwtTokenService {
    private Logger logger = LoggerFactory.getLogger(JwtTokenService.class);

    @Value("${security.jwt.token.secret-key:secret:304859n34swedfs5hhjg}")
    private String secretKey = "95834058347";

    @Value("${security.jwt.token.expire-length:3600000000}")
    private long validityInMilliseconds;

    @PostConstruct
    protected void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    public String resolveToken(HttpServletRequest req) {
        String bearerToken = req.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7, bearerToken.length());
        }
        return null;
    }

    public String createToken(String email) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + validityInMilliseconds);

        return JWT.create()
                .withSubject(email)
                .withIssuedAt(new Date())
                .withExpiresAt(expiryDate)
                .sign(Algorithm.HMAC512(secretKey));
    }

    public boolean validateToken(String authToken) {
        logger.info("Vlaidating: {}", authToken);
        try {
            JWT.require(Algorithm.HMAC512(secretKey)).build().verify(authToken);
            return true;
        } catch (Exception ex) {
            logger.error("Validation failed: {}", ex);
        }
        return false;
    }

    public String getEmailFromToken(String token) {
        return JWT.require(Algorithm.HMAC512(secretKey))
                .build()
                .verify(token)
                .getSubject();

    }
}
