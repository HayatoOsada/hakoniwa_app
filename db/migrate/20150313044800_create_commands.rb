class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.integer :user_id
      t.integer :kind
      t.integer :target
      t.integer :x
      t.integer :y
      t.integer :arg
      t.integer :end

      t.timestamps
    end
  end
end
