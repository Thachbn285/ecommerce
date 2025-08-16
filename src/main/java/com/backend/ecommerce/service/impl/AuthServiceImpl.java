package com.backend.ecommerce.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.entity.UserEntity;
import com.backend.ecommerce.repository.IUserRepo;
import com.backend.ecommerce.service.IAuthService;
import com.backend.ecommerce.utils.JwtTokenUtil;
import com.backend.ecommerce.utils.ResponseDTO;

@Service
public class AuthServiceImpl implements IAuthService {

    private final IUserRepo userRepo;
    private final JwtTokenUtil jwtTokenUtil;
    private final ModelMapper modelMapper;

    public AuthServiceImpl(IUserRepo userRepo, JwtTokenUtil jwtTokenUtil, ModelMapper modelMapper) {
        this.userRepo = userRepo;
        this.jwtTokenUtil = jwtTokenUtil;
        this.modelMapper = modelMapper;
    }

    @Override
    public ResponseDTO login(String username, String password) {
        UserEntity entity = userRepo.findByPhone(username);
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();

        if (entity == null) {
            responseDTO.setMessage("Error");
            String detail = "Username or password is incorrect";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }

        // TODO: Add password verification here
        String token = jwtTokenUtil.generateJwtToken(username);
        responseDTO.setMessage("Success");
        details.add(token);
        responseDTO.setDetails(details);
        return responseDTO;
    }

    @Override
    public ResponseDTO register(RequestUserDTO userDTO) {
        UserEntity existingEntity = userRepo.findByPhone(userDTO.getPhone());
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();

        if (existingEntity != null) {
            responseDTO.setMessage("Error");
            String detail = "User already exists";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }

        PasswordEncoder encoder = new BCryptPasswordEncoder();
        UserEntity entity = modelMapper.map(userDTO, UserEntity.class);
        entity.setPasswordHash(encoder.encode(userDTO.getPasswordHash()));
        userRepo.save(entity);

        responseDTO.setMessage("Success");
        String detail = "User registered successfully";
        details.add(detail);
        responseDTO.setDetails(details);
        return responseDTO;
    }
}
