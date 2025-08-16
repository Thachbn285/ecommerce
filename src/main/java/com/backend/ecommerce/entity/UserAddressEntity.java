package com.backend.ecommerce.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_addresses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserAddressEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "address_type", nullable = false)
    @Builder.Default
    private AddressType addressType = AddressType.BOTH;
    
    @Column(name = "first_name", nullable = false, length = 50)
    private String firstName;
    
    @Column(name = "last_name", nullable = false, length = 50)
    private String lastName;
    
    @Column(name = "company", length = 100)
    private String company;
    
    @Column(name = "address_line1", nullable = false, length = 255)
    private String addressLine1;
    
    @Column(name = "address_line2", length = 255)
    private String addressLine2;
    
    @Column(name = "city", nullable = false, length = 100)
    private String city;
    
    @Column(name = "state", length = 100)
    private String state;
    
    @Column(name = "postal_code", nullable = false, length = 20)
    private String postalCode;
    
    @Column(name = "country", nullable = false, length = 100)
    private String country;
    
    @Column(name = "phone", length = 20)
    private String phone;
    
    @Column(name = "is_default", nullable = false)
    @Builder.Default
    private Boolean isDefault = false;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public enum AddressType {
        BILLING, SHIPPING, BOTH
    }
}
