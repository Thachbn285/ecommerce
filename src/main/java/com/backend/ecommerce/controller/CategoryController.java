package com.backend.ecommerce.controller;

import com.backend.ecommerce.dto.CategoryDTO;
import com.backend.ecommerce.service.ICategoryService;
import com.backend.ecommerce.utils.ResponseDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@Tag(name = "Category Management", description = "Category management APIs")
public class CategoryController {
    
    private final ICategoryService categoryService;
    
    public CategoryController(ICategoryService categoryService) {
        this.categoryService = categoryService;
    }
    
    @PostMapping("/create")
    @Operation(summary = "Create new category", description = "Create a new product category")
    public ResponseEntity<ResponseDTO> createCategory(@RequestBody CategoryDTO categoryDTO) {
        ResponseDTO response = categoryService.createCategory(categoryDTO);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @PutMapping("/update")
    @Operation(summary = "Update category", description = "Update an existing category")
    public ResponseEntity<ResponseDTO> updateCategory(@RequestBody CategoryDTO categoryDTO) {
        ResponseDTO response = categoryService.updateCategory(categoryDTO);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @DeleteMapping("/delete/{id}")
    @Operation(summary = "Delete category", description = "Delete a category by ID")
    public ResponseEntity<ResponseDTO> deleteCategory(@PathVariable Long id) {
        ResponseDTO response = categoryService.deleteCategory(id);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Get category by ID", description = "Get category details by ID")
    public ResponseEntity<CategoryDTO> getCategoryById(@PathVariable Long id) {
        CategoryDTO category = categoryService.getCategoryById(id);
        
        if (category != null) {
            return ResponseEntity.ok(category);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/name/{name}")
    @Operation(summary = "Get category by name", description = "Get category details by name")
    public ResponseEntity<CategoryDTO> getCategoryByName(@PathVariable String name) {
        CategoryDTO category = categoryService.getCategoryByName(name);
        
        if (category != null) {
            return ResponseEntity.ok(category);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/all")
    @Operation(summary = "Get all categories", description = "Get all categories (including inactive)")
    public ResponseEntity<List<CategoryDTO>> getAllCategories() {
        List<CategoryDTO> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/active")
    @Operation(summary = "Get active categories", description = "Get only active categories")
    public ResponseEntity<List<CategoryDTO>> getActiveCategories() {
        List<CategoryDTO> categories = categoryService.getActiveCategories();
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/root")
    @Operation(summary = "Get root categories", description = "Get categories without parent (root level)")
    public ResponseEntity<List<CategoryDTO>> getRootCategories() {
        List<CategoryDTO> categories = categoryService.getRootCategories();
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/hierarchy")
    @Operation(summary = "Get categories hierarchy", description = "Get categories with hierarchical structure")
    public ResponseEntity<List<CategoryDTO>> getCategoriesHierarchy() {
        List<CategoryDTO> categories = categoryService.getCategoriesHierarchy();
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/children/{parentId}")
    @Operation(summary = "Get child categories", description = "Get child categories of a parent category")
    public ResponseEntity<List<CategoryDTO>> getChildCategories(@PathVariable Long parentId) {
        List<CategoryDTO> categories = categoryService.getChildCategories(parentId);
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/with-product-count")
    @Operation(summary = "Get categories with product count", description = "Get categories with their product counts")
    public ResponseEntity<List<CategoryDTO>> getCategoriesWithProductCount() {
        List<CategoryDTO> categories = categoryService.getCategoriesWithProductCount();
        return ResponseEntity.ok(categories);
    }
    
    @GetMapping("/search")
    @Operation(summary = "Search categories", description = "Search categories by name keyword")
    public ResponseEntity<List<CategoryDTO>> searchCategories(@RequestParam String keyword) {
        List<CategoryDTO> categories = categoryService.searchCategories(keyword);
        return ResponseEntity.ok(categories);
    }
    
    @PutMapping("/toggle-status/{id}")
    @Operation(summary = "Toggle category status", description = "Toggle active/inactive status of a category")
    public ResponseEntity<ResponseDTO> toggleCategoryStatus(@PathVariable Long id) {
        ResponseDTO response = categoryService.toggleCategoryStatus(id);
        
        if ("Success".equals(response.getMessage())) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
}
