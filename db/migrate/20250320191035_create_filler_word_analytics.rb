class CreateFillerWordAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :filler_word_analytics do |t|
      t.references :video, null: false, foreign_key: true
      t.string :word
      t.integer :count

      t.timestamps
    end
  end
end
