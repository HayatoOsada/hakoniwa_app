class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :turn
      t.integer :user_id
      t.string :log

      t.timestamps
    end
    add_index  :histories, :user_id
  end
end
