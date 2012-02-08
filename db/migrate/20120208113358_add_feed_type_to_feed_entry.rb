class AddFeedTypeToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :feed_type, :integer
  end
end
