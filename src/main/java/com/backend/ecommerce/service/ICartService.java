package com.backend.ecommerce.service;

import com.backend.ecommerce.dto.CartDTO;
import com.backend.ecommerce.utils.ResponseDTO;

import java.util.List;

public interface ICartService {
    
    /**
     * Add product to cart
     */
    ResponseDTO addToCart(Long userId, Long productId, Integer quantity);
    
    /**
     * Update quantity of product in cart
     */
    ResponseDTO updateCartItem(Long userId, Long productId, Integer quantity);
    
    /**
     * Remove product from cart
     */
    ResponseDTO removeFromCart(Long userId, Long productId);
    
    /**
     * Get all cart items for user
     */
    List<CartDTO> getCartItems(Long userId);
    
    /**
     * Get cart summary (total items, total amount)
     */
    CartDTO getCartSummary(Long userId);
    
    /**
     * Clear all items from cart
     */
    ResponseDTO clearCart(Long userId);
    
    /**
     * Get cart item count for user
     */
    Integer getCartItemCount(Long userId);
}
