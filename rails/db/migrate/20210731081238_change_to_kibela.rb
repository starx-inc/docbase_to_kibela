class ChangeToKibela < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :kibela_id, :string
    add_column :groups, :kibela_id, :string
  end
end
