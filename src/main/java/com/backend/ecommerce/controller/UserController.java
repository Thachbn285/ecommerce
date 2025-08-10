package com.backend.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.backend.ecommerce.dto.request.RequestUserDTO;
import com.backend.ecommerce.dto.response.ResponseUserDTO;
import com.backend.ecommerce.service.IUserService;
import com.backend.ecommerce.utils.ResponseDTO;

@RestController
public class UserController {

    @Autowired
    private IUserService userService;


    @PostMapping("/create-user")
    public ResponseDTO createUser(@RequestBody RequestUserDTO dto) {
        return userService.createUser(dto);
    }

    @PutMapping("/update-user")
    public ResponseDTO updateUser(@RequestBody RequestUserDTO dto) {
        return userService.updateUser(dto);
    }
    @GetMapping("/user/all")
    public List<ResponseUserDTO> getusers(){
        return userService.getAllUsers();
    }
    @GetMapping("/user/{id}")
    public ResponseUserDTO getUser(@PathVariable int id){
        return userService.findUserById(id);
    }

}
