package com.backend.ecommerce.controller;

import java.util.List;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.backend.ecommerce.dto.ProductDTO;
import com.backend.ecommerce.service.IProductService;
import com.backend.ecommerce.utils.ResponseDTO;

@RestController
public class ProductController {

    private final IProductService productService;

    public ProductController(IProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/products/all")
    public List<ProductDTO> findAll() {
        return productService.findAllProducts();
    }

    @GetMapping("/products/{id}")
    public ProductDTO findById(@PathVariable int id) {
        return productService.findById(id);
    }

    @PostMapping("/products/create")
    public ResponseDTO create(@RequestBody ProductDTO productDTO) {
        return productService.create(productDTO);
    }

    @PutMapping("/products/modify")
    public ResponseDTO modify(@RequestBody ProductDTO productDTO) {
        return productService.modify(productDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseDTO delete(@PathVariable int id) {
        return productService.delete(id);
    }

}