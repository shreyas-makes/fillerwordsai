class AddAwsJobIdToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :aws_job_id, :string
    add_column :videos, :processed_at, :datetime
  end
end
