class CreateMessageBords < ActiveRecord::Migration
  def change
    create_table :message_bords do |t|
      t.integer :land_id
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
