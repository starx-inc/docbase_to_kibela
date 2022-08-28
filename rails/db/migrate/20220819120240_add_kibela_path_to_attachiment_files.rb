class AddKibelaPathToAttachimentFiles < ActiveRecord::Migration[6.0]
  def change
    add_column :attachiment_files, :kibela_path, :string
  end
end
