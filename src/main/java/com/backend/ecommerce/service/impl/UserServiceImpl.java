package com.backend.ecommerce.service.impl;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.utils.ResponseDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.backend.ecommerce.repository.IUserRepo;
import com.backend.ecommerce.service.IUserService;

@Service
public class UserServiceImpl implements IUserService {

    @Autowired
    private IUserRepo userRepo;


    @Override
    public ResponseDTO createUser(RequestUserDTO dto) {
        return null;
    }

    @Override
    public ResponseDTO updateUser(RequestUserDTO dto) {
        return null;
    }
}
