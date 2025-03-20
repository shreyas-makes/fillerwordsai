# frozen_string_literal: true

require 'aws-sdk-mediaconvert'

class MediaConvertService
  DEFAULT_FILLER_WORDS = %w[um uh like so basically actually you\ know].freeze
  
  # MediaConvert job statuses
  JOB_STATES = {
    submitted: 'SUBMITTED',
    progressing: 'PROGRESSING',
    complete: 'COMPLETE',
    canceled: 'CANCELED',
    error: 'ERROR'
  }.freeze

  attr_reader :client, :endpoint, :role_arn, :queue_arn, :output_bucket

  def initialize
    @endpoint = Rails.application.credentials.dig(:aws, :mediaconvert, :endpoint)
    @role_arn = Rails.application.credentials.dig(:aws, :mediaconvert, :role_arn)
    @queue_arn = Rails.application.credentials.dig(:aws, :mediaconvert, :queue_arn)
    @output_bucket = Rails.application.credentials.dig(:aws, :mediaconvert, :output_bucket)
    
    @client = Aws::MediaConvert::Client.new(
      region: Rails.application.credentials.dig(:aws, :region),
      endpoint: @endpoint,
      credentials: Aws::Credentials.new(
        Rails.application.credentials.dig(:aws, :access_key_id),
        Rails.application.credentials.dig(:aws, :secret_access_key)
      )
    )
  end

  # Create a new MediaConvert job to process a video
  def create_job(video, filler_words: nil, silence_threshold: 0.5)
    filler_words ||= DEFAULT_FILLER_WORDS
    input_url = video.original_file_url
    output_key = "outputs/#{video.id}/#{video.title.parameterize}"

    job_settings = build_job_settings(
      input_url: input_url,
      output_key: output_key,
      filler_words: filler_words,
      silence_threshold: silence_threshold,
      file_type: video.file_type
    )

    response = client.create_job(
      role: role_arn,
      settings: job_settings,
      queue: queue_arn
    )

    video.update(
      aws_job_id: response.job.id,
      status: 'processing',
      progress: 0,
      processed_file_url: "s3://#{output_bucket}/#{output_key}.mp4"
    )

    response.job.id
  rescue Aws::MediaConvert::Errors::ServiceError => e
    Rails.logger.error "MediaConvert job creation failed: #{e.message}"
    video.update(status: 'failed', error_message: e.message)
    raise
  end

  # Get status of a MediaConvert job
  def get_job_status(job_id)
    response = client.get_job(id: job_id)
    response.job
  rescue Aws::MediaConvert::Errors::ServiceError => e
    Rails.logger.error "Failed to get MediaConvert job status: #{e.message}"
    raise
  end

  # Check if job is complete
  def job_complete?(job_id)
    job = get_job_status(job_id)
    job.status == JOB_STATES[:complete]
  end

  # Update video status based on job status
  def update_video_status(video)
    return if video.aws_job_id.blank?

    job = get_job_status(video.aws_job_id)

    case job.status
    when JOB_STATES[:complete]
      process_completed_job(video, job)
    when JOB_STATES[:progressing]
      update_progress(video, job)
    when JOB_STATES[:error]
      handle_error(video, job)
    end

    job.status
  rescue Aws::MediaConvert::Errors::ServiceError => e
    Rails.logger.error "Error updating video status: #{e.message}"
    video.update(status: 'failed', error_message: e.message)
    'ERROR'
  end

  # Process a job that has completed successfully
  def process_completed_job(video, job)
    video.update(
      status: 'completed',
      progress: 100,
      processed_at: Time.current
    )
    
    # Create analytics for the processed video
    create_filler_word_analytics(video, job)
  end

  # Update video progress during processing
  def update_progress(video, job)
    progress = job.job_percent_complete || 0
    video.update(progress: progress)
  end

  # Handle errors in MediaConvert job
  def handle_error(video, job)
    error_message = job.error_message || 'Unknown error during MediaConvert processing'
    
    if video.retry_count < 3
      # Retry the job
      video.update(
        retry_count: video.retry_count + 1,
        error_message: error_message
      )
      create_job(video) # Retry the job
    else
      # Mark as failed after too many retries
      video.update(
        status: 'failed',
        error_message: error_message
      )
    end
  end

  # Create analytics from the processing results
  def create_filler_word_analytics(video, job)
    # Actual implementation will depend on how MediaConvert returns the filler word data
    # This is a simplified placeholder that would be replaced with actual data extraction
    
    # In a real implementation, we would extract data from job outputs or metadata
    sample_data = {
      'um' => { count: 15, timestamps: [10.5, 45.2, 78.9] },
      'uh' => { count: 8, timestamps: [23.1, 67.4] },
      'like' => { count: 22, timestamps: [5.6, 32.8, 51.7, 89.3] }
    }

    # Save analytics data
    sample_data.each do |word, data|
      video.filler_word_analytics.create!(
        word: word,
        count: data[:count],
        timestamps: data[:timestamps]
      )
    end

    # Update total filler words in the video record
    video.update(filler_words: sample_data)
  end

  private

  # Build the job settings for MediaConvert
  def build_job_settings(input_url:, output_key:, filler_words:, silence_threshold:, file_type:)
    # This is a simplified version of the job settings
    # In a real implementation, this would be much more detailed and specific
    # to the capabilities of MediaConvert and the specific filler word removal logic
    
    # Base settings
    settings = {
      inputs: [
        {
          audio_selectors: {
            'Audio Selector 1' => {
              default_selection: 'DEFAULT'
            }
          },
          file_input: input_url
        }
      ],
      output_groups: [
        {
          custom_name: 'Processed Output',
          output_group_settings: {
            type: 'FILE_GROUP_SETTINGS',
            file_group_settings: {
              destination: "s3://#{output_bucket}/#{output_key}"
            }
          },
          outputs: []
        }
      ]
    }

    # Add the appropriate output configuration based on file type
    if file_type == 'video'
      settings[:output_groups][0][:outputs] << video_output_settings
    else
      settings[:output_groups][0][:outputs] << audio_output_settings
    end

    # Adding script for filler word detection
    # In a real implementation, this would use actual AWS MediaConvert features 
    # for speech recognition and removal
    
    settings
  end

  def video_output_settings
    {
      preset: 'System-Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz',
      extension: 'mp4',
      name_modifier: '_processed'
    }
  end

  def audio_output_settings
    {
      preset: 'System-Audio_Aac_44100Hz_160kbps',
      extension: 'mp3',
      name_modifier: '_processed'
    }
  end
end 