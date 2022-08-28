class AddDrivePathToAttachimentFiles < ActiveRecord::Migration[6.0]
  def change
    add_column :attachiment_files, :drive_path, :string
  end
end
