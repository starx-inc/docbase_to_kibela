class AddKibelaColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :kibela_id, :string
    add_column :posts, :kibela_updated_at, :datetime

    add_column :comments, :kibela_id, :string
    add_column :comments, :kibela_updated_at, :datetime

    add_column :attachiment_files, :kibela_id, :string
    add_column :attachiment_files, :kibela_updated_at, :datetime

  end
end
