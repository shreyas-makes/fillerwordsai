# AWS MediaConvert Integration

## Overview
This step will implement the AWS MediaConvert integration for processing the uploaded audio and video files. We'll create a service class to interact with the AWS MediaConvert API and handle job creation, monitoring, and completion.

## Task
Implement the AWS MediaConvert service to process uploaded files and remove filler words and awkward silences.

## Specific Steps

1. Add AWS MediaConvert SDK:
   - Add the `aws-sdk-mediaconvert` gem to the Gemfile
   - Configure AWS credentials for MediaConvert

2. Create a MediaConvertService class:
   - Implement the core service structure
   - Add methods for creating MediaConvert jobs
   - Add methods for checking job status
   - Implement error handling and retries

3. Create a configuration for filler word detection:
   - Define default list of filler words to detect
   - Configure silence threshold settings
   - Create templates for different types of processing

4. Implement background job processing:
   - Create a Delayed::Job for video processing
   - Handle job submission to AWS MediaConvert
   - Update Video model status during processing
   - Track progress and estimated time remaining

5. Add job status polling:
   - Create a scheduled task to poll for job status
   - Update video records with current progress
   - Handle job completion
   - Handle job failures and retries

## Expected Outcome
A working MediaConvert integration that can process uploaded videos, remove filler words, and update the application with status and results.

## Testing Approach
1. Unit tests:
   - Test MediaConvertService with mocked AWS responses
   - Test background job processing
   - Test error handling and retries

2. Integration tests:
   - Test full workflow with AWS services stubbed
   - Test status updates and polling
   - Test error recovery 