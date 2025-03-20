class AddDescriptionToVideos < ActiveRecord::Migration[8.0]
  def change
    add_column :videos, :description, :text
  end
end
