FactoryBot.define do
  factory :video_processing do
    title { "MyString" }
    file_url { "MyString" }
    status { "MyString" }
    user { nil }
    processed_url { "MyString" }
    file_type { "MyString" }
    processing_duration { 1.5 }
    blacklisted_words { "MyText" }
    pause_threshold { 1.5 }
  end
end
