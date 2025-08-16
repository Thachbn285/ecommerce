package com.backend.ecommerce.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "coupon_usage",
       uniqueConstraints = @UniqueConstraint(columnNames = {"coupon_id", "order_id"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CouponUsageEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "coupon_id", nullable = false)
    private CouponEntity coupon;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private OrderEntity order;
    
    @Column(name = "discount_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal discountAmount;
    
    @Column(name = "used_at", nullable = false, updatable = false)
    private LocalDateTime usedAt;
    
    @PrePersist
    protected void onCreate() {
        usedAt = LocalDateTime.now();
    }
}
