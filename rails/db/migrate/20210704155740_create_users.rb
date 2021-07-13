class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :docbase_id, null:false
      t.string :docbase_name, null: true
      t.string :docbase_email, null: true
      t.integer :kibela_id, null: true
      t.string :kibela_name, null: true
      
      t.timestamps
    end
  end
end
