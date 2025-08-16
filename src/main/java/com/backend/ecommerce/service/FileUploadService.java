package com.backend.ecommerce.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileUploadService {
    String uploadFile(MultipartFile file, String folder);
    boolean deleteFile(String fileName);
    String getFileUrl(String fileName);
}
