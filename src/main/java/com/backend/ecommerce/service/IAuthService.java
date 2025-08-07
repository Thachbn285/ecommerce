package com.backend.ecommerce.service;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.utils.ResponseDTO;

public interface IAuthService {
    public ResponseDTO login(@RequestParam String username, @RequestParam String password);
    public ResponseDTO register(@RequestBody RequestUserDTO userDTO);
}
