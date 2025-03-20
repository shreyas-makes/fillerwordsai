FactoryBot.define do
  factory :video do
    title { "MyString" }
    status { "MyString" }
    original_file_url { "MyString" }
    processed_file_url { "MyString" }
    processing_time { 1 }
    file_type { "MyString" }
    user { nil }
    remaining_time { 1.5 }
    filler_words { "MyText" }
    custom_pause_threshold { 1.5 }
  end
end
