package com.backend.ecommerce.repository;

import com.backend.ecommerce.entity.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IProductRepo extends JpaRepository<ProductEntity, Integer> {
    ProductEntity findByName(String name);

}
