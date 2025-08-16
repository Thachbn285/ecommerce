package com.backend.ecommerce.service;

import java.util.Collection;
import java.util.Collections;

import com.backend.ecommerce.entity.UserEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetail implements UserDetails {

    private UserEntity userEntity;

    public UserEntity getUserEntity(UserEntity userEntity) {
        this.userEntity = userEntity;
        return this.userEntity;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // TODO: Fix when Lombok is working properly
        return Collections.singleton(new SimpleGrantedAuthority("ROLE_CUSTOMER"));
    }

    @Override
    public String getPassword() {
        // TODO: Fix when Lombok is working properly
        return "password";
    }

    @Override
    public String getUsername() {
        // TODO: Fix when Lombok is working properly
        return "username";
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        // TODO: Fix when Lombok is working properly
        return true;
    }
}
