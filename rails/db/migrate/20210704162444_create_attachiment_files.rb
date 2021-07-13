class CreateAttachimentFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :attachiment_files, id: :string do |t|
      t.string :name, limit: 2048
      t.string :url, limit: 2048
      t.text :markdown
      
      t.string :local_path, limit: 2048

      t.timestamps
    end
  end
end
