class CreateImageUsers < ActiveRecord::Migration
  def change
    create_table :image_users do |t|
      t.references :image, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
