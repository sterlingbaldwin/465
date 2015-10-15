class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :url
      t.references :topic, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
