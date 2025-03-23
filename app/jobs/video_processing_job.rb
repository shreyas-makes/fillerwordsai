# frozen_string_literal: true

class VideoProcessingJob < ApplicationJob
  queue_as :default

  def perform(video_id, options = {})
    video = Video.find_by(id: video_id)
    return unless video

    # Default options
    options = {
      filler_words: nil, # Use default if nil
      silence_threshold: video.custom_pause_threshold || 0.5
    }.merge(options)

    service = MediaConvertService.new
    
    begin
      Rails.logger.info "Starting MediaConvert job for video #{video.id}"
      job_id = service.create_job(
        video,
        filler_words: options[:filler_words],
        silence_threshold: options[:silence_threshold]
      )
      
      Rails.logger.info "MediaConvert job #{job_id} created for video #{video.id}"
    rescue => e
      Rails.logger.error "Error creating MediaConvert job: #{e.message}"
      video.update(
        status: 'failed',
        error_message: "Failed to create MediaConvert job: #{e.message}"
      )
    end
  end
end 