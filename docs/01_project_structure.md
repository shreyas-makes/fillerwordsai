# Project Structure Setup

## Overview
This first step will establish the foundation for our FillerWordsAI project based on the Speedrail framework. We'll set up the basic models and relationships needed for the application.

## Task
Set up the core models for the FillerWordsAI project and their relationships. We're building on the Speedrail framework, which already provides User authentication through Devise.

## Specific Steps

1. Create a migration to add user fields required for FillerWordsAI:
   - `plan_type` (string): to track subscription type (monthly/one_time)
   - `credits_remaining` (integer): to track remaining credits for one-time payment users
   - `custom_filler_words` (text): to store serialized array of custom filler words
   - `silence_threshold` (float): to store the user's preferred silence threshold

2. Create a Video model with:
   - `title` (string): name of the video
   - `status` (string): current status (pending/processing/completed/failed)
   - `original_file_url` (string): URL to the original file
   - `processed_file_url` (string): URL to the processed file
   - `processing_time` (integer): time taken to process the video
   - `file_type` (string): video/audio
   - `user_id` (references): foreign key to the user
   - `remaining_time` (float): estimated time remaining for processing
   - `filler_words` (text): serialized array of detected filler words
   - `custom_pause_threshold` (float): custom silence threshold for this video
   - `progress` (integer): processing progress percentage
   - `error_message` (text): error message if processing failed
   - `job_id` (string): AWS MediaConvert job ID
   - `retry_count` (integer): number of retry attempts

3. Create a FillerWordAnalytic model with:
   - `video_id` (references): foreign key to the video
   - `word` (string): the detected filler word
   - `count` (integer): number of occurrences

4. Set up model relationships:
   - User has_many Videos
   - Video belongs_to User
   - Video has_many FillerWordAnalytics
   - FillerWordAnalytic belongs_to Video

5. Implement basic validations for each model.

6. Add necessary serialization for array fields.

## Expected Outcome
A solid foundation with properly defined models and relationships that will support the core functionality of the FillerWordsAI application.

## Testing Approach
Write model tests to verify:
- Validations work as expected
- Relationships are set up correctly
- Serialization works for array fields 