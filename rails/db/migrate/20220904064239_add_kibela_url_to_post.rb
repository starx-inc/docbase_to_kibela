class AddKibelaUrlToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :kibela_url, :string
  end
end
