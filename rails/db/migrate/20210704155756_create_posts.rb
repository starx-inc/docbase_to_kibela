class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :user, null: true, foreign_key: true
      t.string :title, limit: 1024
      t.text :body
      t.string :origin_url, limit: 1024
      t.string :scope, limit: 255
      t.timestamps
    end
  end
end
