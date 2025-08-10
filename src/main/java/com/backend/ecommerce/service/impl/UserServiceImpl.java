package com.backend.ecommerce.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.backend.ecommerce.config.ModelMapperConfig;
import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.dto.response.ResponseUserDTO;
import com.backend.ecommerce.entity.UserEntity;
import com.backend.ecommerce.repository.IUserRepo;
import com.backend.ecommerce.service.IUserService;
import com.backend.ecommerce.utils.ResponseDTO;

@Service
public class UserServiceImpl implements IUserService {

    @Autowired
    private IUserRepo userRepo;
    @Autowired
    private ModelMapper modelMapper;

    @Override
    public ResponseDTO createUser(RequestUserDTO dto) {
        UserEntity userEntity = userRepo.findByPhone(dto.getPhone());
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        if (userEntity.getFirstName() != null) {
            responseDTO.setMessage("Error");
            String detail = "User Existed";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        } else {
            userEntity = modelMapper.map(dto, UserEntity.class);
            userRepo.save(userEntity);
            responseDTO.setMessage("Success");
            String detail = "Created new user successfully";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }

    @Override
    public ResponseDTO updateUser(RequestUserDTO dto) {
        UserEntity userEntity = userRepo.findByPhone(dto.getPhone());
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        if (userEntity.getFirstName() == null) {
            responseDTO.setMessage("Error");
            String detail = "User is not existed, update fail";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        } else {
            userEntity = modelMapper.map(dto, UserEntity.class);
            userRepo.save(userEntity);
            responseDTO.setMessage("Success");
            String detail = "Updated new user successfully";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }

    @Override
    public List<ResponseUserDTO> getAllUsers() {
        List<UserEntity> userEntities = userRepo.findAll();
        List<ResponseUserDTO> Users = userEntities.stream()
                .map(user -> modelMapper.map(userEntities, ResponseUserDTO.class))
                .toList();
        return Users;
    }

    @Override
    public ResponseUserDTO findUserById(int id) {
        Optional<UserEntity> userEntity = userRepo.findById(id);
        if (userEntity.isPresent()) {
            return modelMapper.map(userEntity, ResponseUserDTO.class);
        } else {
            return null;
        }
    }
}
