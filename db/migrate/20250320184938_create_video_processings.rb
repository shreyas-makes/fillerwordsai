class CreateVideoProcessings < ActiveRecord::Migration[8.0]
  def change
    create_table :video_processings do |t|
      t.string :title
      t.string :file_url
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.string :processed_url
      t.string :file_type
      t.float :processing_duration
      t.text :blacklisted_words
      t.float :pause_threshold

      t.timestamps
    end
  end
end
