package com.backend.ecommerce.service;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.utils.ResponseDTO;

public interface IUserService {

    ResponseDTO createUser(RequestUserDTO dto);

    ResponseDTO updateUser(RequestUserDTO dto);
}
