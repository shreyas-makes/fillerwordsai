class UploadsController < ApplicationController
  before_action :authenticate_user!

  def new
    @video = Video.new
  end

  def create
    @video = current_user.videos.new(video_params)
    @video.status = 'pending'
    @video.progress = 0
    @video.retry_count = 0

    if params[:video][:file].blank?
      @video.errors.add(:file, "is required")
      return render :new, status: :unprocessable_entity
    end

    # Attach the blob to the video
    blob = ActiveStorage::Blob.find_signed(params[:video][:file])
    @video.file.attach(blob)
    
    # Set file type based on content type
    content_type = blob.content_type
    if content_type.start_with?('video/')
      @video.file_type = 'video'
    elsif content_type.start_with?('audio/')
      @video.file_type = 'audio'
    end
    
    # Now validate the attached file
    validator = FileValidationService.new(blob)
    unless validator.validate
      validator.errors.each do |error|
        @video.errors.add(:file, error)
      end
      @video.file.purge # Remove the invalid file
      return render :new, status: :unprocessable_entity
    end
    
    # Set the original file URL
    @video.original_file_url = url_for(@video.file) if @video.file.attached?

    if @video.save
      # This would trigger processing in a real implementation
      # ProcessVideoJob.perform_later(@video.id)
      redirect_to dashboard_index_path, notice: 'Video was successfully uploaded and will be processed shortly.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :custom_pause_threshold, :file)
  end
end 