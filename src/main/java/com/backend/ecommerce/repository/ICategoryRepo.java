package com.backend.ecommerce.repository;

import com.backend.ecommerce.entity.CategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ICategoryRepo extends JpaRepository<CategoryEntity, Long> {

    /**
     * Find category by name
     */
    Optional<CategoryEntity> findByName(String name);

    /**
     * Find category by slug
     */
    Optional<CategoryEntity> findBySlug(String slug);

    /**
     * Find all active categories
     */
    List<CategoryEntity> findByIsActiveTrueOrderBySortOrderAsc();

    /**
     * Find root categories (no parent)
     */
    List<CategoryEntity> findByParentIdIsNullOrderBySortOrderAsc();

    /**
     * Find active root categories
     */
    List<CategoryEntity> findByParentIdIsNullAndIsActiveTrueOrderBySortOrderAsc();

    /**
     * Find child categories by parent ID
     */
    List<CategoryEntity> findByParentIdOrderBySortOrderAsc(Long parentId);

    /**
     * Find active child categories by parent ID
     */
    List<CategoryEntity> findByParentIdAndIsActiveTrueOrderBySortOrderAsc(Long parentId);

    /**
     * Search categories by name containing keyword
     */
    List<CategoryEntity> findByNameContainingIgnoreCaseOrderByName(String keyword);

    /**
     * Check if category name exists (excluding current category)
     */
    boolean existsByNameAndIdNot(String name, Long id);

    /**
     * Check if category has children
     */
    boolean existsByParentId(Long parentId);

    /**
     * Count products in category
     */
    @Query("SELECT COUNT(p) FROM ProductEntity p WHERE p.category.id = :categoryId")
    Long countProductsByCategoryId(@Param("categoryId") Long categoryId);

    /**
     * Get categories with product count
     */
    @Query("SELECT c, COUNT(p) FROM CategoryEntity c LEFT JOIN ProductEntity p ON c.id = p.category.id " +
            "WHERE c.isActive = true GROUP BY c ORDER BY c.sortOrder ASC")
    List<Object[]> findCategoriesWithProductCount();
}
