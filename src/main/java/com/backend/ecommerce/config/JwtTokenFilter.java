package com.backend.ecommerce.config;

import java.io.IOException;

import org.springframework.lang.NonNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.backend.ecommerce.service.CustomUserDetail;
import com.backend.ecommerce.service.impl.CustomUserDetailService;
import com.backend.ecommerce.utils.JwtTokenUtil;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtTokenFilter extends OncePerRequestFilter {
    @Autowired
    private JwtTokenUtil jwtTokenUtil;

    @Autowired
    private CustomUserDetailService customUserDetailService;

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain)
            throws ServletException, IOException {
        if (isByPassToken(request)) {
            filterChain.doFilter(request, response);
            return;
        }
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authorize header is invalid");
            return;
        }

        String token = authHeader.substring(7);
        String username = jwtTokenUtil.getUsernameFromToken(token);
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            CustomUserDetail user = (CustomUserDetail) customUserDetailService.loadUserByUsername(username);
            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(user, null,
                    user.getAuthorities());
            auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        filterChain.doFilter(request, response);
    }

    private boolean isByPassToken(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String method = request.getMethod();

        // List of endpoints that don't require authentication
        return (uri.equals("/products/all") && method.equals("GET")) ||
                (uri.equals("/login") && method.equals("POST")) ||
                (uri.equals("/register") && method.equals("POST")) ||
                (uri.startsWith("/swagger-ui")) ||
                (uri.startsWith("/api-docs")) ||
                (uri.startsWith("/uploads/"));
    }
}
