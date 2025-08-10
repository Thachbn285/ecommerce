package com.backend.ecommerce.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.backend.ecommerce.dto.ProductDTO;
import com.backend.ecommerce.entity.ProductEntity;
import com.backend.ecommerce.repository.IProductRepo;
import com.backend.ecommerce.service.IProductService;
import com.backend.ecommerce.utils.ResponseDTO;

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

    @Override
    public ResponseDTO create(ProductDTO productDTO) {
        ProductEntity productEntity = productRepo.findByName(productDTO.getName());
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        if (productEntity.getName() != null) {
            responseDTO.setMessage("Error");
            String detail = "Product is existed";
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }
        responseDTO.setMessage("Success");
        String detail = "Created successful product";
        details.add(detail);
        responseDTO.setDetails(details);
        return responseDTO;
    }

    @Override
    public ResponseDTO modify(ProductDTO productDTO) {
        ResponseDTO responseDTO = new ResponseDTO();
        ProductEntity productEntity = productRepo.findByName(productDTO.getName());
        if (productEntity.getName() == null) {
            responseDTO.setMessage("Error");
            String detail = "Product is not existed, modify unsuccessful";
            List<String> details = new ArrayList<>();
            details.add(detail);
            responseDTO.setDetails(details);
            return responseDTO;
        }
        productEntity = modelMapper.map(productDTO, ProductEntity.class);
        productRepo.save(productEntity);
        String detail = "Modify successfully";
        responseDTO.setMessage("Success");
        List<String> details = new ArrayList<>();
        details.add(detail);
        return responseDTO;
    }
}
