package com.backend.ecommerce.service.impl;

import java.util.List;
import java.util.Optional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.backend.ecommerce.dto.ProductDTO;
import com.backend.ecommerce.entity.ProductEntity;
import com.backend.ecommerce.repository.IProductRepo;
import com.backend.ecommerce.service.IProductService;

@Service
public class ProductServiceImpl implements IProductService {
    @Autowired
    IProductRepo productRepo;
    @Autowired
    ModelMapper modelMapper;

    @Override
    public List<ProductDTO> findAllProducts() {
        List<ProductEntity> productEntities = productRepo.findAll();
        return productEntities.stream().map(entity -> modelMapper.map(entity, ProductDTO.class)).toList();
    }

    @Override
    public ProductDTO findById(Integer id) {
        Optional<ProductEntity> productEntity = productRepo.findById(id);
        if (productEntity.isEmpty()) {
            return null;
        }
        return productEntity.map(entity -> modelMapper.map(entity, ProductDTO.class)).orElse(null);
    }
}
