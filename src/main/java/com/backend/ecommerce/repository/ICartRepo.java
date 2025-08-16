package com.backend.ecommerce.repository;

import com.backend.ecommerce.entity.ShoppingCartEntity;
import com.backend.ecommerce.entity.UserEntity;
import com.backend.ecommerce.entity.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ICartRepo extends JpaRepository<ShoppingCartEntity, Long> {
    
    /**
     * Find cart item by user and product
     */
    Optional<ShoppingCartEntity> findByUserAndProduct(UserEntity user, ProductEntity product);
    
    /**
     * Find all cart items for a user
     */
    List<ShoppingCartEntity> findByUserOrderByAddedAtDesc(UserEntity user);
    
    /**
     * Find all cart items by user ID
     */
    @Query("SELECT c FROM ShoppingCartEntity c WHERE c.user.id = :userId ORDER BY c.addedAt DESC")
    List<ShoppingCartEntity> findByUserIdOrderByAddedAtDesc(@Param("userId") Long userId);
    
    /**
     * Count total items in cart for user
     */
    @Query("SELECT COALESCE(SUM(c.quantity), 0) FROM ShoppingCartEntity c WHERE c.user.id = :userId")
    Integer countTotalItemsByUserId(@Param("userId") Long userId);
    
    /**
     * Delete all cart items for user
     */
    void deleteByUser(UserEntity user);
    
    /**
     * Delete cart item by user and product
     */
    void deleteByUserAndProduct(UserEntity user, ProductEntity product);
    
    /**
     * Check if product exists in user's cart
     */
    boolean existsByUserAndProduct(UserEntity user, ProductEntity product);
}
