package com.backend.ecommerce.service.impl;

import com.backend.ecommerce.service.FileUploadService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileUploadServiceImpl implements FileUploadService {

    @Value("${file.upload.dir:./uploads/}")
    private String uploadDir;

    @Override
    public String uploadFile(MultipartFile file, String folder) {
        try {
            // Validate file
            if (file.isEmpty()) {
                throw new RuntimeException("File is empty");
            }

            // Create upload directory if not exists
            Path uploadPath = Paths.get(uploadDir, folder);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Generate unique filename
            String originalFilename = file.getOriginalFilename();
            String fileExtension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String uniqueFilename = UUID.randomUUID().toString() + fileExtension;

            // Save file
            Path filePath = uploadPath.resolve(uniqueFilename);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            return folder + "/" + uniqueFilename;
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload file: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteFile(String fileName) {
        try {
            Path filePath = Paths.get(uploadDir, fileName);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            return false;
        }
    }

    @Override
    public String getFileUrl(String fileName) {
        return "/uploads/" + fileName;
    }
}
