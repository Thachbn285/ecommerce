package com.backend.ecommerce.controller;

import com.backend.ecommerce.service.FileUploadService;
import com.backend.ecommerce.utils.ResponseDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/files")
@Tag(name = "File Upload", description = "File upload management APIs")
public class FileUploadController {

    @Autowired
    private FileUploadService fileUploadService;

    @PostMapping("/upload")
    @Operation(summary = "Upload a file", description = "Upload a single file to the server")
    public ResponseEntity<ResponseDTO> uploadFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "folder", defaultValue = "general") String folder) {
        
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            String fileName = fileUploadService.uploadFile(file, folder);
            String fileUrl = fileUploadService.getFileUrl(fileName);
            
            responseDTO.setMessage("Success");
            details.add("File uploaded successfully");
            details.add("File URL: " + fileUrl);
            responseDTO.setDetails(details);
            
            return ResponseEntity.ok(responseDTO);
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to upload file: " + e.getMessage());
            responseDTO.setDetails(details);
            
            return ResponseEntity.badRequest().body(responseDTO);
        }
    }

    @PostMapping("/upload-multiple")
    @Operation(summary = "Upload multiple files", description = "Upload multiple files to the server")
    public ResponseEntity<ResponseDTO> uploadMultipleFiles(
            @RequestParam("files") MultipartFile[] files,
            @RequestParam(value = "folder", defaultValue = "general") String folder) {
        
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        try {
            for (MultipartFile file : files) {
                String fileName = fileUploadService.uploadFile(file, folder);
                String fileUrl = fileUploadService.getFileUrl(fileName);
                details.add("File URL: " + fileUrl);
            }
            
            responseDTO.setMessage("Success");
            details.add(0, "All files uploaded successfully");
            responseDTO.setDetails(details);
            
            return ResponseEntity.ok(responseDTO);
        } catch (Exception e) {
            responseDTO.setMessage("Error");
            details.add("Failed to upload files: " + e.getMessage());
            responseDTO.setDetails(details);
            
            return ResponseEntity.badRequest().body(responseDTO);
        }
    }

    @DeleteMapping("/delete")
    @Operation(summary = "Delete a file", description = "Delete a file from the server")
    public ResponseEntity<ResponseDTO> deleteFile(@RequestParam("fileName") String fileName) {
        ResponseDTO responseDTO = new ResponseDTO();
        List<String> details = new ArrayList<>();
        
        boolean deleted = fileUploadService.deleteFile(fileName);
        
        if (deleted) {
            responseDTO.setMessage("Success");
            details.add("File deleted successfully");
        } else {
            responseDTO.setMessage("Error");
            details.add("Failed to delete file or file not found");
        }
        
        responseDTO.setDetails(details);
        return ResponseEntity.ok(responseDTO);
    }
}
