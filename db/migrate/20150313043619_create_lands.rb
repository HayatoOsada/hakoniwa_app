class CreateLands < ActiveRecord::Migration
  def change
    create_table :lands do |t|
      t.integer :user_id
      t.string  :prize
      t.integer :absent
      t.string  :comment
      t.integer :money
      t.integer :food
      t.integer :people
      t.integer :area
      t.integer :farm
      t.integer :factory
      t.integer :mountain
      t.integer :score
      t.text    :land
      t.text    :land_value

      t.timestamps
    end

    add_index  :lands, :user_id
  end
end
