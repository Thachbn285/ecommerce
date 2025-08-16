package com.backend.ecommerce.service.impl;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.backend.ecommerce.service.CustomUserDetail;
import com.backend.ecommerce.entity.UserEntity;
import com.backend.ecommerce.repository.IUserRepo;

@Service
public class CustomUserDetailService implements UserDetailsService {
    private IUserRepo userRepo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserEntity userEntity = userRepo.findByPhone(username);
        CustomUserDetail customUserDetail = new CustomUserDetail();
        customUserDetail.getUserEntity(userEntity);
        return customUserDetail;
    }
}
