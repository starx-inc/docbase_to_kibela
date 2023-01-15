class CreateFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.references :group
      t.timestamps
    end
    add_foreign_key :folders, :groups
  end
end
