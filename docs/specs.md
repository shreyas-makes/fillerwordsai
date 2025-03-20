# FillerWordsAI: Developer-Ready Specification

## 1. Project Overview

FillerWordsAI is a web application built on the Speedrail Rails framework that automates the removal of filler words and awkward silences from audio and video content. The service targets podcasters and creative professionals who need a simple post-production tool to clean their recordings.

## 2. Technical Stack

### Core Framework
- Speedrail (Rails 8-based framework)
- Ruby 3.3.5
- PostgreSQL database

### Existing Speedrail Gems
- Devise (authentication)
- ActiveAdmin (admin panel)
- Delayed (background jobs)
- AWS-SDK-S3 (file storage)
- TailwindCSS + Flowbite (frontend styling)
- RSpec (testing)
- Stripe (payment processing)
- Chartkick (for analytics visualization)

### Additional Required Gems
- `aws-sdk-mediaconvert` - For AWS MediaConvert integration
- `active_storage_validations` - For enhanced file validations

## 3. Feature Requirements

### 3.1 User Authentication
- Email/password signup and login via Devise
- Password reset functionality
- Account management (profile editing, subscription management)

### 3.2 Subscription Model
- **Monthly plan**: $30/month with unlimited processing
- **One-time payment**: $150 for 10 videos per month
- Integration with Stripe for payment processing
- Quota tracking system

### 3.3 File Upload
- Support for MP4 (video) and MP3 (audio) files
- Maximum file duration: 1 hour
- Drag-and-drop interface with progress indicators
- Client-side validation for file format, size, and duration

### 3.4 Processing Configuration
- Default filler word detection (um, uh, like, etc.)
- User-configurable filler word blacklist
- Adjustable silence threshold (default: 2.5 seconds)
- Settings persistence per user

### 3.5 Processing Engine
- Integration with AWS MediaConvert
- Background job queue for processing using Delayed
- Status tracking with percentage complete
- Estimated time remaining calculation
- Error handling with retry mechanism
- Before/after comparison preview

### 3.6 User Dashboard
- Processing history with status indicators
- Remaining credits counter for one-time payment users
- Settings management interface
- Download section for processed files

### 3.7 Admin Features
- User management through ActiveAdmin
- Subscription management
- Usage analytics dashboard with Chartkick
- System monitoring

## 4. Data Architecture

### 4.1 Database Models

#### User (extends Devise model)
```ruby
# Fields from Speedrail's User model:
# - email:string
# - encrypted_password:string
# - admin:boolean
# - stripe_customer_id:string
# - stripe_subscription_id:string
# - paying_customer:boolean
#
# Additional fields needed:
# - plan_type:string (monthly/one_time)
# - credits_remaining:integer
# - custom_filler_words:text (serialized array)
# - silence_threshold:float (default: 2.5)
```

#### Video
```ruby
# Fields already in migration:
# - title:string
# - status:string (pending/processing/completed/failed)
# - original_file_url:string
# - processed_file_url:string
# - processing_time:integer
# - file_type:string (video/audio)
# - user_id:references
# - remaining_time:float
# - filler_words:text (serialized array of detected words)
# - custom_pause_threshold:float
# - created_at:datetime
# - updated_at:datetime
#
# Additional fields needed:
# - progress:integer
# - error_message:text
# - job_id:string (AWS MediaConvert job ID)
# - retry_count:integer (default: 0)
```

#### FillerWordAnalytic
```ruby
# Fields:
# - video_id:references
# - word:string
# - count:integer
# - created_at:datetime
# - updated_at:datetime
```

### 4.2 File Storage
- AWS S3 bucket structure:
  - `/uploads/{user_id}/original/` - Original files
  - `/uploads/{user_id}/processed/` - Processed files
  - Files kept for 3 months after last user login
- Configure `config/storage.yml` and update `config/environments/production.rb` to use S3

## 5. API Integration

### 5.1 AWS MediaConvert Integration
- Separate service class for MediaConvert interactions
- Job template creation for consistent processing
- Response handling and status monitoring

```ruby
class MediaConvertService
  def initialize(user)
    @user = user
    # AWS configuration from credentials
  end
  
  def create_job(video)
    # Create MediaConvert job with the proper parameters
    # Return job ID for tracking
  end
  
  def check_job_status(job_id)
    # Query AWS for job status
    # Return progress, estimated time remaining, and status
  end
  
  # Additional methods for handling AWS MediaConvert interactions
end
```

## 6. User Interface

### 6.1 Main Screens
- Login/Signup page
- Dashboard with upload section and processing history
- Settings page for filler word customization and silence threshold
- Billing/subscription management

### 6.2 Design Approach
- Minimal, straightforward design using Tailwind CSS and Flowbite components
- Mobile-responsive layout following Speedrail's design patterns
- Intuitive file upload process with clear status indicators

## 7. Processing Workflow

1. User uploads a video/audio file
2. System validates the file (format, size, duration limits)
3. File is uploaded to AWS S3
4. Background job is created using Delayed
5. AWS MediaConvert job is initiated with user's settings
6. Regular status polling updates progress in dashboard
7. Upon completion, user receives dashboard notification
8. Before/after preview is generated
9. User can download the processed file
10. Analytics are recorded for admin dashboard

## 8. Error Handling

### 8.1 Upload Errors
- Proper validation messages for invalid file types
- Size limit warnings before upload attempt
- Graceful handling of network interruptions

### 8.2 Processing Errors
- Automatic retry (up to 3 times) for transient AWS errors
- Detailed error logging for debugging
- User-friendly error messages in dashboard
- Failed processing jobs don't count against quota

## 9. Testing Strategy

### 9.1 Unit Tests
- Model validations and business logic
- Service class interactions with AWS services (mocked)
- Controller actions and authentication

### 9.2 Integration Tests
- File upload and processing flow (with AWS stubbed)
- User authentication and subscription handling
- Admin dashboard functionality

### 9.3 End-to-End Tests
- Complete user journey from signup to file processing
- Edge cases like large files and error conditions

## 10. Deployment Architecture

### 10.1 AWS Services
- EC2 or ECS for application hosting
- S3 for file storage
- MediaConvert for video processing
- CloudWatch for monitoring and logging

### 10.2 Scaling Considerations
- Background worker scaling for high processing loads
- Database performance monitoring
- S3 transfer acceleration for large files

## 11. Security Considerations

- Encrypted file transfer and storage
- User authentication and authorization using Devise
- Rate limiting for API endpoints
- Regular security audits
- GDPR/CCPA compliance for user data

## 12. Analytics Requirements

- Track number of uploads
- Monitor processing time
- Analyze file sizes
- Record common filler words detected
- User retention and conversion metrics

## 13. Implementation Timeline

1. **Phase 1 (2 weeks)**: Core setup, authentication, file upload
2. **Phase 2 (2 weeks)**: AWS MediaConvert integration, processing logic
3. **Phase 3 (1 week)**: User dashboard, settings customization
4. **Phase 4 (1 week)**: Subscription management, admin features
5. **Phase 5 (1 week)**: Testing and optimization

## 14. First Steps for Implementation

1. Initialize Speedrail application
2. Create `Video` and `FillerWordAnalytic` models and migrations
3. Update User model with subscription fields
4. Set up AWS credentials and S3 buckets
5. Implement ActiveAdmin resources for Video management
6. Create MediaConvert integration service class

This specification provides a comprehensive blueprint for building the FillerWordsAI application using the Speedrail framework and AWS services. The developer can begin implementation immediately following the outlined approach and architecture.