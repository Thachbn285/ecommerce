package com.backend.ecommerce.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
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
    @Autowired
    private IUserRepo userRepo;
    private JwtTokenUtil jwtTokenUtil;
    private ModelMapper modelMapper;
    private ResponseDTO responseDTO;
    List<String> details = new ArrayList<>();

    @Override
    public ResponseDTO login(String username, String password) {
        UserEntity entity = userRepo.findByPhone(password);
        if (entity.getPhone() == null) {
            responseDTO.message = "Error";
            String detail = "username or password is incorrect ";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }
        String token = jwtTokenUtil.generateJwtToken(username);
        responseDTO.setMessage("Success");
        details.add(token);
        responseDTO.setDetails(details);
        return responseDTO;
    }

    @Override
    public ResponseDTO register(RequestUserDTO userDTO) {
        UserEntity entity = userRepo.findByPhone(userDTO.getPhone());
        if (entity.getPhone() != null) {
            responseDTO.setMessage("Error");
            String detail = "User is existed";
            details.add(detail);
            responseDTO.setDetails(details);
        }
        PasswordEncoder encoder = new BCryptPasswordEncoder();
        entity = modelMapper.map(userDTO, UserEntity.class);
        entity.setPasswordHash(encoder.encode(userDTO.getPasswordHash()));
        userRepo.save(entity);
        responseDTO.setMessage("Success");
        String detail = "User is registed";
        details.add(detail);
        responseDTO.setDetails(details);
        return responseDTO;
    }
}
