package com.backend.ecommerce.utils;

import com.backend.ecommerce.entity.CustomUserDetail;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtTokenUtil {
    private final String jwtSecret = "mySecretKeymySecretKeymySecretKeymySecretKey";
    private final long expireTime = 5 * 24 * 3600000;
    private final CustomUserDetail customUserDetail;

    public JwtTokenUtil(CustomUserDetail customUserDetail) {
        this.customUserDetail = customUserDetail;
    }

    public String generateJwtToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        String role = customUserDetail.getAuthorities().iterator().next().getAuthority();
        claims.put("ROLE", role);
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(username)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis()+expireTime))
                .signWith(SignatureAlgorithm.ES512, jwtSecret)
                .compact();
    }
    public String getRoleFromToken(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(jwtSecret)
                .parseClaimsJws(token)
                .getBody();
        return claims.get("ROLE", String.class);
    }
    public String getUsernameFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(jwtSecret)
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }

    public Date getExpirationDateFromToken(String token) {
        return Jwts.parser()
                .setSigningKey(jwtSecret)
                .parseClaimsJws(token)
                .getBody()
                .getExpiration();
    }

    public boolean isValidateToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .setSigningKey(jwtSecret)
                    .parseClaimsJws(token)
                    .getBody();
            Date expiration = claims.getExpiration();
            return expiration.after(new Date(System.currentTimeMillis()));
        } catch (Exception e) {
            return false;
        }
    }

}
