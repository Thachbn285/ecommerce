package com.backend.ecommerce.service;

import com.backend.ecommerce.dto.CategoryDTO;
import com.backend.ecommerce.utils.ResponseDTO;

import java.util.List;

public interface ICategoryService {
    
    /**
     * Create new category
     */
    ResponseDTO createCategory(CategoryDTO categoryDTO);
    
    /**
     * Update existing category
     */
    ResponseDTO updateCategory(CategoryDTO categoryDTO);
    
    /**
     * Delete category by ID
     */
    ResponseDTO deleteCategory(Long categoryId);
    
    /**
     * Get category by ID
     */
    CategoryDTO getCategoryById(Long categoryId);
    
    /**
     * Get category by name
     */
    CategoryDTO getCategoryByName(String name);
    
    /**
     * Get all categories (flat list)
     */
    List<CategoryDTO> getAllCategories();
    
    /**
     * Get only active categories
     */
    List<CategoryDTO> getActiveCategories();
    
    /**
     * Get root categories (no parent)
     */
    List<CategoryDTO> getRootCategories();
    
    /**
     * Get categories with hierarchical structure
     */
    List<CategoryDTO> getCategoriesHierarchy();
    
    /**
     * Get child categories of a parent
     */
    List<CategoryDTO> getChildCategories(Long parentId);
    
    /**
     * Get categories with product count
     */
    List<CategoryDTO> getCategoriesWithProductCount();
    
    /**
     * Search categories by name
     */
    List<CategoryDTO> searchCategories(String keyword);
    
    /**
     * Toggle category active status
     */
    ResponseDTO toggleCategoryStatus(Long categoryId);
}
