package com.backend.ecommerce.service.impl;

import com.backend.ecommerce.dto.CartDTO;
import com.backend.ecommerce.entity.ProductEntity;
import com.backend.ecommerce.entity.ShoppingCartEntity;
import com.backend.ecommerce.entity.UserEntity;
import com.backend.ecommerce.repository.ICartRepo;
import com.backend.ecommerce.repository.IProductRepo;
import com.backend.ecommerce.repository.IUserRepo;
import com.backend.ecommerce.service.ICartService;
import com.backend.ecommerce.utils.ResponseDTO;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class CartServiceImpl implements ICartService {
    
    private final ICartRepo cartRepo;
    private final IUserRepo userRepo;
    private final IProductRepo productRepo;
    private final ModelMapper modelMapper;
    
    public CartServiceImpl(ICartRepo cartRepo, IUserRepo userRepo, 
                          IProductRepo productRepo, ModelMapper modelMapper) {
        this.cartRepo = cartRepo;
        this.userRepo = userRepo;
        this.productRepo = productRepo;
        this.modelMapper = modelMapper;
    }
    
    @Override
    public ResponseDTO addToCart(Long userId, Long productId, Integer quantity) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            // Validate user
            Optional<UserEntity> userOpt = userRepo.findById(Math.toIntExact(userId));
            if (userOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("User not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Validate product
            Optional<ProductEntity> productOpt = productRepo.findById(Math.toIntExact(productId));
            if (productOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("Product not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            UserEntity user = userOpt.get();
            ProductEntity product = productOpt.get();
            
            // Check if product is active
            if (!product.getIsActive()) {
                responseDTO.setMessage("Error");
                details.add("Product is not available");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Check stock
            if (product.getStockQuantity() < quantity) {
                responseDTO.setMessage("Error");
                details.add("Insufficient stock. Available: " + product.getStockQuantity());
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Check if item already exists in cart
            Optional<ShoppingCartEntity> existingCartItem = cartRepo.findByUserAndProduct(user, product);
            
            if (existingCartItem.isPresent()) {
                // Update quantity
                ShoppingCartEntity cartItem = existingCartItem.get();
                int newQuantity = cartItem.getQuantity() + quantity;
                
                if (product.getStockQuantity() < newQuantity) {
                    responseDTO.setMessage("Error");
                    details.add("Cannot add more items. Total would exceed stock. Available: " + product.getStockQuantity());
                    responseDTO.setDetails(details);
                    return responseDTO;
                }
                
                cartItem.setQuantity(newQuantity);
                cartItem.setUpdatedAt(LocalDateTime.now());
                cartRepo.save(cartItem);
                
                responseDTO.setMessage("Success");
                details.add("Cart updated successfully");
            } else {
                // Create new cart item
                ShoppingCartEntity cartItem = ShoppingCartEntity.builder()
                        .user(user)
                        .product(product)
                        .quantity(quantity)
                        .addedAt(LocalDateTime.now())
                        .updatedAt(LocalDateTime.now())
                        .build();
                
                cartRepo.save(cartItem);
                
                responseDTO.setMessage("Success");
                details.add("Product added to cart successfully");
            }
            
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to add product to cart: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    public ResponseDTO updateCartItem(Long userId, Long productId, Integer quantity) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            if (quantity <= 0) {
                return removeFromCart(userId, productId);
            }
            
            Optional<UserEntity> userOpt = userRepo.findById(Math.toIntExact(userId));
            Optional<ProductEntity> productOpt = productRepo.findById(Math.toIntExact(productId));
            
            if (userOpt.isEmpty() || productOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("User or Product not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            UserEntity user = userOpt.get();
            ProductEntity product = productOpt.get();
            
            Optional<ShoppingCartEntity> cartItemOpt = cartRepo.findByUserAndProduct(user, product);
            
            if (cartItemOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("Cart item not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Check stock
            if (product.getStockQuantity() < quantity) {
                responseDTO.setMessage("Error");
                details.add("Insufficient stock. Available: " + product.getStockQuantity());
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            ShoppingCartEntity cartItem = cartItemOpt.get();
            cartItem.setQuantity(quantity);
            cartItem.setUpdatedAt(LocalDateTime.now());
            cartRepo.save(cartItem);
            
            responseDTO.setMessage("Success");
            details.add("Cart item updated successfully");
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to update cart item: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    public ResponseDTO removeFromCart(Long userId, Long productId) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            Optional<UserEntity> userOpt = userRepo.findById(Math.toIntExact(userId));
            Optional<ProductEntity> productOpt = productRepo.findById(Math.toIntExact(productId));
            
            if (userOpt.isEmpty() || productOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("User or Product not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            UserEntity user = userOpt.get();
            ProductEntity product = productOpt.get();
            
            cartRepo.deleteByUserAndProduct(user, product);
            
            responseDTO.setMessage("Success");
            details.add("Product removed from cart successfully");
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to remove product from cart: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CartDTO> getCartItems(Long userId) {
        try {
            List<ShoppingCartEntity> cartItems = cartRepo.findByUserIdOrderByAddedAtDesc(userId);
            
            return cartItems.stream().map(this::convertToCartDTO).collect(Collectors.toList());
            
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public CartDTO getCartSummary(Long userId) {
        try {
            List<ShoppingCartEntity> cartItems = cartRepo.findByUserIdOrderByAddedAtDesc(userId);
            
            int totalItems = cartItems.stream().mapToInt(ShoppingCartEntity::getQuantity).sum();
            BigDecimal totalAmount = cartItems.stream()
                    .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            
            return CartDTO.builder()
                    .userId(userId)
                    .totalItems(totalItems)
                    .totalAmount(totalAmount)
                    .build();
            
        } catch (Exception e) {
            return CartDTO.builder()
                    .userId(userId)
                    .totalItems(0)
                    .totalAmount(BigDecimal.ZERO)
                    .build();
        }
    }
    
    @Override
    public ResponseDTO clearCart(Long userId) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            Optional<UserEntity> userOpt = userRepo.findById(Math.toIntExact(userId));
            
            if (userOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("User not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            UserEntity user = userOpt.get();
            cartRepo.deleteByUser(user);
            
            responseDTO.setMessage("Success");
            details.add("Cart cleared successfully");
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to clear cart: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public Integer getCartItemCount(Long userId) {
        try {
            return cartRepo.countTotalItemsByUserId(userId);
        } catch (Exception e) {
            return 0;
        }
    }
    
    private CartDTO convertToCartDTO(ShoppingCartEntity cartItem) {
        ProductEntity product = cartItem.getProduct();
        BigDecimal subtotal = product.getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity()));
        
        return CartDTO.builder()
                .id(cartItem.getId())
                .userId(cartItem.getUser().getId().longValue())
                .productId(product.getId().longValue())
                .productName(product.getName())
                .productSku(product.getSku())
                .productPrice(product.getPrice())
                .quantity(cartItem.getQuantity())
                .subtotal(subtotal)
                .addedAt(cartItem.getAddedAt())
                .updatedAt(cartItem.getUpdatedAt())
                .build();
    }
}
