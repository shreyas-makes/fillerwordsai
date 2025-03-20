# File Upload and Storage Implementation

## Overview
In this step, we'll implement the file upload functionality with AWS S3 integration for storage. We'll add the necessary configuration and controllers to handle video and audio file uploads.

## Task
Set up the file upload system with proper validations, storage configuration, and controller actions.

## Specific Steps

1. Update AWS S3 configuration:
   - Configure `config/storage.yml` for AWS S3
   - Update environment configurations to use S3 in production
   - Configure local storage for development

2. Create an UploadController to handle file uploads:
   - Implement a route for file uploads
   - Create controller actions for handling uploads
   - Validate file formats (MP4, MP3)
   - Validate file size
   - Generate and store file URLs in the Video model

3. Create frontend components for file upload:
   - Create a drag-and-drop interface using Stimulus.js
   - Implement progress indicators for uploads
   - Add client-side validation for file formats and size
   - Display appropriate error messages for invalid files

4. Implement file validation service:
   - Create a service to validate video/audio duration
   - Check if file is valid MP4/MP3
   - Limit file duration to 1 hour

5. Update Video model:
   - Add methods to track upload status
   - Add callbacks to handle file uploads
   - Implement file type detection

## Expected Outcome
A working file upload system that allows users to upload MP4 and MP3 files. The system should validate files, store them in S3 (or locally in development), and create proper Video records with the correct metadata.

## Testing Approach
1. Unit tests:
   - Test file validation logic
   - Test controller actions with mocked file uploads

2. Integration tests:
   - Test successful file upload flow
   - Test validation error handling
   - Test storage configuration 