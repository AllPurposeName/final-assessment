class AddLanguageTable < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.boolean :preferred, default: false
      t.timestamps null: false
    end
  end
end
