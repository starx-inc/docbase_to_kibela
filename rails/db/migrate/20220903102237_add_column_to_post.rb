class AddColumnToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :is_duplicated, :boolean
    add_column :posts, :duplicated_url, :string
  end
end
