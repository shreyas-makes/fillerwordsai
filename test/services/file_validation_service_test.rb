require 'test_helper'

class FileValidationServiceTest < ActiveSupport::TestCase
  setup do
    @mock_video = Struct.new(:content_type, :size).new('video/mp4', 10.megabytes)
    @mock_audio = Struct.new(:content_type, :size).new('audio/mpeg', 5.megabytes)
    @mock_invalid_type = Struct.new(:content_type, :size).new('application/pdf', 1.megabyte)
    @mock_large_file = Struct.new(:content_type, :size).new('video/mp4', 2.gigabytes)
  end

  test "validates a valid video file" do
    service = FileValidationService.new(@mock_video)
    assert service.validate
    assert_empty service.errors
  end

  test "validates a valid audio file" do
    service = FileValidationService.new(@mock_audio)
    assert service.validate
    assert_empty service.errors
  end

  test "rejects invalid file type" do
    service = FileValidationService.new(@mock_invalid_type)
    assert_not service.validate
    assert_not_empty service.errors
    assert_includes service.errors.first, "File type not supported"
  end

  test "rejects files that are too large" do
    service = FileValidationService.new(@mock_large_file)
    assert_not service.validate
    assert_not_empty service.errors
    assert_includes service.errors.first, "File is too large"
  end

  test "handles nil file" do
    service = FileValidationService.new(nil)
    assert_not service.validate
    assert_empty service.errors
  end
end 