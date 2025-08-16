package com.backend.ecommerce.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.service.IAuthService;
import com.backend.ecommerce.utils.ResponseDTO;

@RestController
public class AuthController {

    private final IAuthService authService;

    public AuthController(IAuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseDTO login(@RequestParam String phoneNumber, @RequestParam String password) {
        return authService.login(phoneNumber, password);
    }

    @PostMapping("/register")
    public ResponseDTO register(@RequestBody RequestUserDTO dto) {
        return authService.register(dto);
    }
}
