package com.backend.ecommerce.service;

import com.backend.ecommerce.dto.ProductDTO;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface IProductService {
    List<ProductDTO> findAllProducts();
    ProductDTO findById(@RequestParam Integer id);
}
