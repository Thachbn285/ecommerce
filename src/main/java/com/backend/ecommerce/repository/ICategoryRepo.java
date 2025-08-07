package com.backend.ecommerce.repository;

import com.backend.ecommerce.entity.CategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ICategoryRepo extends JpaRepository<CategoryEntity, Integer> {
    CategoryEntity findByName(String name);
}
