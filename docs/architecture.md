# Architecture for FillerWordsAI

## Status: Approved

## Technical Summary

FillerWordsAI is a web-based application built on the Speedrail (Rails 8) framework that automates the removal of filler words and awkward silences from audio and video content. The system employs a client-server architecture with AWS services integration for media processing. This architecture provides a scalable, user-friendly solution for podcasters and creative professionals who need to clean their recordings.

## Technology Table

| Technology         | Description                                                         |
|-------------------|---------------------------------------------------------------------|
| Rails 8           | Core web application framework                                       |
| Ruby 3.3.5        | Programming language                                                 |
| PostgreSQL        | Relational database for data persistence                             |
| AWS S3            | Cloud storage for original and processed media files                 |
| AWS MediaConvert  | Media processing service for removing filler words                   |
| Stripe            | Payment processing for subscriptions and one-time payments           |
| Devise            | Authentication system for user management                            |
| ActiveAdmin       | Administration dashboard                                             |
| Delayed           | Background job processing                                            |
| TailwindCSS       | CSS framework for responsive UI                                      |
| Flowbite          | UI component library built on TailwindCSS                            |
| RSpec             | Testing framework                                                    |
| Chartkick         | Data visualization for analytics                                     |

## Architectural Diagrams

```mermaid
graph TD
    A[User] -->|Upload MP3/MP4| B[Web Application]
    B -->|Store Original| C[(AWS S3)]
    B -->|Create Job| D[Background Worker]
    D -->|Process Media| E[AWS MediaConvert]
    E -->|Store Processed| C
    D -->|Update Status| F[(PostgreSQL DB)]
    B -->|Read Data| F
    B -->|Process Payment| G[Stripe API]
    Admin -->|Manage System| H[Admin Panel]
    H -->|Read/Write Data| F
    
    style A fill:#f9f,stroke:#333
    style B fill:#bbf,stroke:#333
    style C fill:#bfb,stroke:#333
    style D fill:#fbf,stroke:#333
    style E fill:#fbb,stroke:#333
    style F fill:#bff,stroke:#333
```

```mermaid
sequenceDiagram
    participant U as User
    participant W as Web Application
    participant DB as PostgreSQL
    participant BG as Background Worker
    participant S3 as AWS S3
    participant MC as AWS MediaConvert

    U->>W: Upload Media File
    W->>S3: Store Original File
    W->>DB: Create Video Record (status: pending)
    W->>BG: Enqueue Processing Job
    BG->>MC: Create MediaConvert Job
    BG->>DB: Update Status (processing)
    
    loop Status Check
        BG->>MC: Check Job Status
        BG->>DB: Update Progress
    end
    
    MC->>S3: Store Processed File
    BG->>DB: Update Status (completed)
    U->>W: Request Download
    W->>S3: Retrieve Processed File
    W->>U: Deliver Processed File
```

## Data Models

### Entity Relationship Diagram

```mermaid
erDiagram
    User ||--o{ Video : "has many"
    Video ||--o{ FillerWordAnalytic : "has many"
    
    User {
        string email
        string encrypted_password
        boolean admin
        string stripe_customer_id
        string stripe_subscription_id
        boolean paying_customer
        string plan_type
        integer credits_remaining
        text custom_filler_words
        float silence_threshold
    }
    
    Video {
        string title
        string status
        string original_file_url
        string processed_file_url
        integer processing_time
        string file_type
        integer user_id
        float remaining_time
        text filler_words
        float custom_pause_threshold
        integer progress
        text error_message
        string job_id
        integer retry_count
    }
    
    FillerWordAnalytic {
        integer video_id
        string word
        integer count
    }
```

## API Integrations

### AWS MediaConvert

The application integrates with AWS MediaConvert to process media files:

```ruby
# Pseudo-code for MediaConvert service integration
class MediaConvertService
  def initialize(user)
    @user = user
    # AWS configuration
  end
  
  def create_job(video)
    # Create MediaConvert job with settings
    # Return job ID
  end
  
  def check_job_status(job_id)
    # Get job status from AWS
    # Return progress and time estimates
  end
end
```

### Stripe Payment API

The application integrates with Stripe for subscription and one-time payments:

```ruby
# Pseudo-code for Stripe integration
class SubscriptionService
  def create_subscription(user, plan_type)
    # Create Stripe subscription for user
  end
  
  def process_one_time_payment(user)
    # Process one-time payment and add credits
  end
end
```

## Project Structure

```
/
├── /app
│   ├── /controllers            # Application controllers
│   ├── /models                 # Data models (User, Video, FillerWordAnalytic)
│   ├── /views                  # UI templates
│   ├── /services               # Service objects (MediaConvertService, etc.)
│   ├── /jobs                   # Background jobs (ProcessVideoJob, etc.)
│   ├── /helpers                # View helpers
│   ├── /admin                  # ActiveAdmin resources
│   └── /assets                 # CSS, JavaScript, images
├── /config                     # Application configuration
├── /db                         # Database migrations and schema
├── /lib                        # Library code and tasks
├── /spec                       # Tests
└── /docs                       # Documentation
```

## Processing Flow

1. User uploads a file through the web interface
2. File passes validation and is stored in AWS S3
3. A Video record is created with status "pending"
4. A background job is enqueued to process the file
5. The job creates an AWS MediaConvert job with user's settings
6. The background worker polls for job status regularly
7. Upon completion, the processed file URL is updated
8. Analytics are generated based on detected filler words
9. User is notified and can download the processed file

## Security Considerations

- All media files are stored in private S3 buckets with appropriate permissions
- User authentication is handled through Devise
- Subscription data is processed securely via Stripe
- Database contains no sensitive media content, only metadata and URLs
- AWS credentials are stored securely using Rails' encrypted credentials
- HTTPS is enforced for all connections

## Change Log

| Change               | Story ID | Description                                     |
|----------------------|----------|-------------------------------------------------|
| Initial Architecture | N/A      | Initial approved system design and documentation | 