class FileValidationService
  MAX_DURATION_SECONDS = 3600 # 1 hour
  MAX_FILE_SIZE = 1.gigabyte
  VALID_VIDEO_TYPES = %w[video/mp4 video/quicktime video/mpeg].freeze
  VALID_AUDIO_TYPES = %w[audio/mpeg audio/mp3 audio/mp4 audio/x-m4a].freeze
  VALID_CONTENT_TYPES = VALID_VIDEO_TYPES + VALID_AUDIO_TYPES

  def initialize(file)
    @file = file
    @errors = []
  end

  def validate
    return false if @file.nil?

    validate_content_type
    validate_file_size
    # We'd use external tools or gems for this in a real implementation
    # validate_duration 

    @errors.empty?
  end

  def errors
    @errors
  end

  private

  def validate_content_type
    content_type = @file.respond_to?(:content_type) ? @file.content_type : @file.content_type.to_s
    return if VALID_CONTENT_TYPES.include?(content_type)

    @errors << "File type not supported. Please upload an MP4 video or MP3 audio file."
  end

  def validate_file_size
    file_size = @file.respond_to?(:size) ? @file.size : @file.byte_size
    return if file_size <= MAX_FILE_SIZE

    @errors << "File is too large. Maximum size is #{MAX_FILE_SIZE / 1.megabyte} MB."
  end

  # This would normally use a media processing library like FFMPEG
  # def validate_duration
  #   duration = get_file_duration(@file)
  #   return if duration <= MAX_DURATION_SECONDS
  #
  #   @errors << "File duration exceeds the maximum of 1 hour."
  # end
  #
  # def get_file_duration(file)
  #   # This would use a gem like streamio-ffmpeg in a real implementation
  #   # movie = FFMPEG::Movie.new(file.path)
  #   # movie.duration
  #   60 # Placeholder return value
  # end
end 