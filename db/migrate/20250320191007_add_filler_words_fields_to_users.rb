class AddFillerWordsFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :plan_type, :string
    add_column :users, :credits_remaining, :integer
    add_column :users, :custom_filler_words, :text
    add_column :users, :silence_threshold, :float
  end
end
