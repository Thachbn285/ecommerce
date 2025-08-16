package com.backend.ecommerce.controller;

import com.backend.ecommerce.dto.CartDTO;
import com.backend.ecommerce.service.ICartService;
import com.backend.ecommerce.utils.ResponseDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
@Tag(name = "Shopping Cart", description = "Shopping cart management APIs")
public class CartController {
    
    private final ICartService cartService;
    
    public CartController(ICartService cartService) {
        this.cartService = cartService;
    }
    
    @PostMapping("/add")
    @Operation(summary = "Add product to cart", description = "Add a product to user's shopping cart")
    public ResponseEntity<ResponseDTO> addToCart(
            @RequestParam Long userId,
            @RequestParam Long productId,
            @RequestParam(defaultValue = "1") Integer quantity) {
        
        ResponseDTO response = cartService.addToCart(userId, productId, quantity);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PutMapping("/update")
    @Operation(summary = "Update cart item quantity", description = "Update quantity of a product in cart")
    public ResponseEntity<ResponseDTO> updateCartItem(
            @RequestParam Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {
        
        ResponseDTO response = cartService.updateCartItem(userId, productId, quantity);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @DeleteMapping("/remove")
    @Operation(summary = "Remove product from cart", description = "Remove a product from user's cart")
    public ResponseEntity<ResponseDTO> removeFromCart(
            @RequestParam Long userId,
            @RequestParam Long productId) {
        
        ResponseDTO response = cartService.removeFromCart(userId, productId);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping("/items/{userId}")
    @Operation(summary = "Get cart items", description = "Get all items in user's cart")
    public ResponseEntity<List<CartDTO>> getCartItems(@PathVariable Long userId) {
        List<CartDTO> cartItems = cartService.getCartItems(userId);
        return ResponseEntity.ok(cartItems);
    }
    
    @GetMapping("/summary/{userId}")
    @Operation(summary = "Get cart summary", description = "Get cart summary with total items and amount")
    public ResponseEntity<CartDTO> getCartSummary(@PathVariable Long userId) {
        CartDTO summary = cartService.getCartSummary(userId);
        return ResponseEntity.ok(summary);
    }
    
    @GetMapping("/count/{userId}")
    @Operation(summary = "Get cart item count", description = "Get total number of items in user's cart")
    public ResponseEntity<Integer> getCartItemCount(@PathVariable Long userId) {
        Integer count = cartService.getCartItemCount(userId);
        return ResponseEntity.ok(count);
    }
    
    @DeleteMapping("/clear/{userId}")
    @Operation(summary = "Clear cart", description = "Remove all items from user's cart")
    public ResponseEntity<ResponseDTO> clearCart(@PathVariable Long userId) {
        ResponseDTO response = cartService.clearCart(userId);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
}
