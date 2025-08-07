package com.backend.ecommerce.controller;

import org.modelmapper.internal.bytebuddy.asm.Advice.Return;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.service.IAuthService;
import com.backend.ecommerce.service.IUserService;
import com.backend.ecommerce.utils.ResponseDTO;

@RestController
public class UserController {

    @Autowired
    private IUserService userService;
    @Autowired
    private IAuthService authService;

    @PostMapping("/login")
    public ResponseDTO login(@RequestParam String phoneNumber, @RequestParam String password) {
        return authService.login(phoneNumber, password);
    }

    @PostMapping("/register")
    public ResponseDTO register(@RequestBody RequestUserDTO dto) {
        return authService.register(dto);
    }

    @PostMapping("/create-user")
    public ResponseDTO createUser(@RequestBody RequestUserDTO dto) {
        return userService.createUser(dto);
    }

    @PutMapping("/update-user")
    public ResponseDTO updateUser(@RequestBody RequestUserDTO dto) {
        return userService.updateUser(dto);
    }

}
