package com.backend.ecommerce.controller;

import com.backend.ecommerce.dto.ProductDTO;
import com.backend.ecommerce.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ProductController {
    @Autowired
    private IProductService iProductService;

    @GetMapping("/products/all")
    public List<ProductDTO> findAll() {
        return iProductService.findAllProducts();
    }

    @GetMapping("/products/{id}")
    public ProductDTO findById(@PathVariable Integer id) {
        return iProductService.findById(id);
    }




}
