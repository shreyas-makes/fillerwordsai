class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: [:show, :edit, :update, :destroy, :process_video]

  def index
    @videos = current_user.videos.order(created_at: :desc)
  end

  def show
  end

  def new
    @video = Video.new
  end

  def create
    @video = current_user.videos.new(video_params)
    
    if @video.save
      redirect_to @video, notice: 'Video was successfully uploaded.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @video.update(video_params)
      redirect_to @video, notice: 'Video was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_path, notice: 'Video was successfully deleted.'
  end

  def process_video
    if @video.start_processing
      redirect_to @video, notice: 'Video processing has started.'
    else
      redirect_to @video, alert: 'Cannot start processing. Video might already be in processing state.'
    end
  end

  private

  def set_video
    @video = current_user.videos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to videos_path, alert: 'Video not found'
  end

  def video_params
    params.require(:video).permit(:title, :file, :description, :custom_pause_threshold)
  end
end 