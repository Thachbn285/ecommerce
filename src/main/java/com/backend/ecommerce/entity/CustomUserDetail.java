package com.backend.ecommerce.entity;

import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetail implements UserDetails {

    private UserEntity userEntity;
    public UserEntity getUserEntity(UserEntity userEntity) {
        return this.userEntity = userEntity;
    }


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(new SimpleGrantedAuthority("USER_" + userEntity.getRole().toUpperCase()));
    }

    @Override
    public String getPassword() {
        return userEntity.getPasswordHash();
    }

    @Override
    public String getUsername() {
        return userEntity.getPhone();
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
        return true;
    }

}
