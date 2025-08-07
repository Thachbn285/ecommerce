package com.backend.ecommerce.repository;

import com.backend.ecommerce.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IUserRepo extends JpaRepository<UserEntity, Integer> {
    UserEntity findByPhone(String phone);
}
