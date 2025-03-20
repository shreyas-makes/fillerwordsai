class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :status
      t.string :original_file_url
      t.string :processed_file_url
      t.integer :processing_time
      t.string :file_type
      t.references :user, null: false, foreign_key: true
      t.float :remaining_time
      t.text :filler_words
      t.float :custom_pause_threshold

      t.timestamps
    end
  end
end
