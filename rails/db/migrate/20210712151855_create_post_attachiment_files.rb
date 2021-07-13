class CreatePostAttachimentFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :post_attachiment_files do |t|
      t.references :post, null: false, foreign_key: true
      t.references :attachiment_file, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
