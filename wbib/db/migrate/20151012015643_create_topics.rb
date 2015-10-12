class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :title
      t.string :description

      t.timestamps null: false
    end
  end
end
