package com.backend.ecommerce.service.impl;

import com.backend.ecommerce.dto.CategoryDTO;
import com.backend.ecommerce.entity.CategoryEntity;
import com.backend.ecommerce.repository.ICategoryRepo;
import com.backend.ecommerce.service.ICategoryService;
import com.backend.ecommerce.utils.ResponseDTO;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class CategoryServiceImpl implements ICategoryService {
    
    private final ICategoryRepo categoryRepo;
    private final ModelMapper modelMapper;
    
    public CategoryServiceImpl(ICategoryRepo categoryRepo, ModelMapper modelMapper) {
        this.categoryRepo = categoryRepo;
        this.modelMapper = modelMapper;
    }
    
    @Override
    public ResponseDTO createCategory(CategoryDTO categoryDTO) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            // Check if category name already exists
            Optional<CategoryEntity> existingCategory = categoryRepo.findByName(categoryDTO.getName());
            if (existingCategory.isPresent()) {
                responseDTO.setMessage("Error");
                details.add("Category name already exists");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Validate parent category if provided
            if (categoryDTO.getParentId() != null) {
                Optional<CategoryEntity> parentCategory = categoryRepo.findById(categoryDTO.getParentId());
                if (parentCategory.isEmpty()) {
                    responseDTO.setMessage("Error");
                    details.add("Parent category not found");
                    responseDTO.setDetails(details);
                    return responseDTO;
                }
            }
            
            // Create new category
            CategoryEntity categoryEntity = CategoryEntity.builder()
                    .name(categoryDTO.getName())
                    .description(categoryDTO.getDescription())
                    .slug(generateSlug(categoryDTO.getName()))
                    .imageUrl(categoryDTO.getImageUrl())
                    .parentId(categoryDTO.getParentId())
                    .isActive(categoryDTO.getIsActive() != null ? categoryDTO.getIsActive() : true)
                    .sortOrder(categoryDTO.getSortOrder() != null ? categoryDTO.getSortOrder() : 0)
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build();
            
            categoryRepo.save(categoryEntity);
            
            responseDTO.setMessage("Success");
            details.add("Category created successfully");
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to create category: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    public ResponseDTO updateCategory(CategoryDTO categoryDTO) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            Optional<CategoryEntity> categoryOpt = categoryRepo.findById(categoryDTO.getId());
            if (categoryOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("Category not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Check if name exists for other categories
            if (categoryRepo.existsByNameAndIdNot(categoryDTO.getName(), categoryDTO.getId())) {
                responseDTO.setMessage("Error");
                details.add("Category name already exists");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            CategoryEntity categoryEntity = categoryOpt.get();
            categoryEntity.setName(categoryDTO.getName());
            categoryEntity.setDescription(categoryDTO.getDescription());
            categoryEntity.setSlug(generateSlug(categoryDTO.getName()));
            categoryEntity.setImageUrl(categoryDTO.getImageUrl());
            categoryEntity.setParentId(categoryDTO.getParentId());
            categoryEntity.setIsActive(categoryDTO.getIsActive());
            categoryEntity.setSortOrder(categoryDTO.getSortOrder());
            categoryEntity.setUpdatedAt(LocalDateTime.now());
            
            categoryRepo.save(categoryEntity);
            
            responseDTO.setMessage("Success");
            details.add("Category updated successfully");
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to update category: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    public ResponseDTO deleteCategory(Long categoryId) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            Optional<CategoryEntity> categoryOpt = categoryRepo.findById(categoryId);
            if (categoryOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("Category not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Check if category has children
            if (categoryRepo.existsByParentId(categoryId)) {
                responseDTO.setMessage("Error");
                details.add("Cannot delete category with child categories");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            // Check if category has products
            Long productCount = categoryRepo.countProductsByCategoryId(categoryId);
            if (productCount > 0) {
                responseDTO.setMessage("Error");
                details.add("Cannot delete category with products. Move products first.");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            categoryRepo.deleteById(categoryId);
            
            responseDTO.setMessage("Success");
            details.add("Category deleted successfully");
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to delete category: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public CategoryDTO getCategoryById(Long categoryId) {
        try {
            Optional<CategoryEntity> categoryOpt = categoryRepo.findById(categoryId);
            if (categoryOpt.isPresent()) {
                return convertToCategoryDTO(categoryOpt.get());
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public CategoryDTO getCategoryByName(String name) {
        try {
            Optional<CategoryEntity> categoryOpt = categoryRepo.findByName(name);
            if (categoryOpt.isPresent()) {
                return convertToCategoryDTO(categoryOpt.get());
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> getAllCategories() {
        try {
            List<CategoryEntity> categories = categoryRepo.findAll();
            return categories.stream()
                    .map(this::convertToCategoryDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> getActiveCategories() {
        try {
            List<CategoryEntity> categories = categoryRepo.findByIsActiveTrueOrderBySortOrderAsc();
            return categories.stream()
                    .map(this::convertToCategoryDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> getRootCategories() {
        try {
            List<CategoryEntity> categories = categoryRepo.findByParentIdIsNullAndIsActiveTrueOrderBySortOrderAsc();
            return categories.stream()
                    .map(this::convertToCategoryDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> getCategoriesHierarchy() {
        try {
            List<CategoryEntity> rootCategories = categoryRepo.findByParentIdIsNullAndIsActiveTrueOrderBySortOrderAsc();
            return rootCategories.stream()
                    .map(this::convertToCategoryDTOWithChildren)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> getChildCategories(Long parentId) {
        try {
            List<CategoryEntity> categories = categoryRepo.findByParentIdAndIsActiveTrueOrderBySortOrderAsc(parentId);
            return categories.stream()
                    .map(this::convertToCategoryDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> getCategoriesWithProductCount() {
        try {
            List<Object[]> results = categoryRepo.findCategoriesWithProductCount();
            return results.stream()
                    .map(result -> {
                        CategoryEntity category = (CategoryEntity) result[0];
                        Long productCount = (Long) result[1];
                        CategoryDTO dto = convertToCategoryDTO(category);
                        dto.setProductCount(productCount.intValue());
                        return dto;
                    })
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryDTO> searchCategories(String keyword) {
        try {
            List<CategoryEntity> categories = categoryRepo.findByNameContainingIgnoreCaseOrderByName(keyword);
            return categories.stream()
                    .map(this::convertToCategoryDTO)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
    
    @Override
    public ResponseDTO toggleCategoryStatus(Long categoryId) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            Optional<CategoryEntity> categoryOpt = categoryRepo.findById(categoryId);
            if (categoryOpt.isEmpty()) {
                responseDTO.setMessage("Error");
                details.add("Category not found");
                responseDTO.setDetails(details);
                return responseDTO;
            }
            
            CategoryEntity category = categoryOpt.get();
            category.setIsActive(!category.getIsActive());
            category.setUpdatedAt(LocalDateTime.now());
            categoryRepo.save(category);
            
            responseDTO.setMessage("Success");
            details.add("Category status updated to: " + (category.getIsActive() ? "Active" : "Inactive"));
            responseDTO.setDetails(details);
            return responseDTO;
            
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to toggle category status: " + e.getMessage());
            responseDTO.setDetails(details);
            return responseDTO;
        }
    }
    
    private CategoryDTO convertToCategoryDTO(CategoryEntity entity) {
        CategoryDTO dto = modelMapper.map(entity, CategoryDTO.class);
        
        // Get parent name if exists
        if (entity.getParentId() != null) {
            Optional<CategoryEntity> parent = categoryRepo.findById(entity.getParentId());
            if (parent.isPresent()) {
                dto.setParentName(parent.get().getName());
            }
        }
        
        return dto;
    }
    
    private CategoryDTO convertToCategoryDTOWithChildren(CategoryEntity entity) {
        CategoryDTO dto = convertToCategoryDTO(entity);
        
        // Get children
        List<CategoryEntity> children = categoryRepo.findByParentIdAndIsActiveTrueOrderBySortOrderAsc(entity.getId());
        List<CategoryDTO> childrenDTOs = children.stream()
                .map(this::convertToCategoryDTO)
                .collect(Collectors.toList());
        
        dto.setChildren(childrenDTOs);
        return dto;
    }
    
    private String generateSlug(String name) {
        return name.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .trim();
    }
}
