package com.backend.ecommerce.dto.response;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ResponseUserDTO {
    private Integer id;
    private String email;
    private String firstName;
    private String lastName;
    private String phone;
    private LocalDate dateOfBirth;
    private Gender gender;
    private String avatarUrl;
    private LocalDateTime emailVerifiedAt;
    private UserStatus status = UserStatus.active;
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    public enum Gender {
        male, female, other
    }

    public enum UserStatus {
        active, inactive, suspended
    }
}
