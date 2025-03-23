# frozen_string_literal: true

# Start the MediaConvert status polling job when the application starts
Rails.application.config.after_initialize do
  if defined?(Rails::Server) && !Rails.env.test?
    # Only start in server mode, not during rake tasks etc.
    MediaConvertStatusJob.perform_later
  end
end 