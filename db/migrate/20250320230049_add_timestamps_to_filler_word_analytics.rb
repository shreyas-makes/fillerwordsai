class AddTimestampsToFillerWordAnalytics < ActiveRecord::Migration[8.0]
  def change
    add_column :filler_word_analytics, :timestamps, :text
  end
end
