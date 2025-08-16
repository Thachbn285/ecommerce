package com.backend.ecommerce.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "product_reviews",
       uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "product_id", "order_id"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductReviewEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private ProductEntity product;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private OrderEntity order;
    
    @Column(name = "rating", nullable = false)
    private Integer rating; // 1-5 stars
    
    @Column(name = "title", length = 255)
    private String title;
    
    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;
    
    @Column(name = "is_verified_purchase", nullable = false)
    @Builder.Default
    private Boolean isVerifiedPurchase = false;
    
    @Column(name = "is_approved", nullable = false)
    @Builder.Default
    private Boolean isApproved = false;
    
    @Column(name = "helpful_count", nullable = false)
    @Builder.Default
    private Integer helpfulCount = 0;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        
        // Validate rating
        if (rating != null && (rating < 1 || rating > 5)) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
        
        // Validate rating
        if (rating != null && (rating < 1 || rating > 5)) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }
}
