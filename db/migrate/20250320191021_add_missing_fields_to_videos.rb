class AddMissingFieldsToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :progress, :integer
    add_column :videos, :error_message, :text
    add_column :videos, :job_id, :string
    add_column :videos, :retry_count, :integer
  end
end
