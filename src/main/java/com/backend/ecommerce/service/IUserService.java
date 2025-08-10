package com.backend.ecommerce.service;

import java.util.List;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.dto.response.ResponseUserDTO;
import com.backend.ecommerce.utils.ResponseDTO;

public interface IUserService {

    ResponseDTO createUser(RequestUserDTO dto);

    ResponseDTO updateUser(RequestUserDTO dto);
    List<ResponseUserDTO> getAllUsers();
    ResponseUserDTO findUserById(int id);
}
