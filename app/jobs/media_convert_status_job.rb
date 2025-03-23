# frozen_string_literal: true

class MediaConvertStatusJob < ApplicationJob
  queue_as :default

  def perform
    # Find all videos that are in processing state
    processing_videos = Video.where(status: 'processing')
    return if processing_videos.empty?

    service = MediaConvertService.new

    processing_videos.each do |video|
      next if video.aws_job_id.blank?

      begin
        Rails.logger.info "Checking status for MediaConvert job #{video.aws_job_id} for video #{video.id}"
        status = service.update_video_status(video)
        Rails.logger.info "MediaConvert job status: #{status} for video #{video.id}"
      rescue => e
        Rails.logger.error "Error checking MediaConvert job status: #{e.message}"
      end
    end

    # Re-schedule self to run again after a delay
    MediaConvertStatusJob.set(wait: 1.minute).perform_later
  end
end 