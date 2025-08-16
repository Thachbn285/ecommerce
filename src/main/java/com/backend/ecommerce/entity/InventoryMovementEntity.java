package com.backend.ecommerce.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "inventory_movements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InventoryMovementEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private ProductEntity product;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "movement_type", nullable = false)
    private MovementType movementType;
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "reference_type", nullable = false)
    private ReferenceType referenceType;
    
    @Column(name = "reference_id")
    private Long referenceId;
    
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "created_by")
    private Long createdBy; // User ID who made the movement
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    public enum MovementType {
        IN, OUT, ADJUSTMENT
    }
    
    public enum ReferenceType {
        PURCHASE, SALE, RETURN, ADJUSTMENT, DAMAGE
    }
}
