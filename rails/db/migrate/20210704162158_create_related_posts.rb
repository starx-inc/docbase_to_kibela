class CreateRelatedPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :related_posts do |t|
      t.references :reference_post, null: false, foreign_key: { to_table: :posts }
      t.references :source_post, null: false, foreign_key: { to_table: :posts }
      t.boolean :converted, default: false
      t.timestamps
    end
  end
end
