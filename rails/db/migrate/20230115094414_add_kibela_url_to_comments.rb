class AddKibelaUrlToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :kibela_url, :string
  end
end
