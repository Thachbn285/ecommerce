package com.backend.ecommerce.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "order_tracking")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderTrackingEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    private OrderEntity order;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private TrackingStatus status;
    
    @Column(name = "location", length = 255)
    private String location;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    public enum TrackingStatus {
        ORDER_PLACED, PAYMENT_CONFIRMED, PROCESSING, SHIPPED, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    }
}
