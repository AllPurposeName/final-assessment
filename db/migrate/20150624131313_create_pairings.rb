class CreatePairings < ActiveRecord::Migration
  def change
    create_table :pairings do |t|
      t.references :user, index: true, foreign_key: true
      t.references :pair, index: true, foreign_key: true
      t.boolean :paired_before, default: false
      t.boolean :interested, default: false
      t.boolean :completed, default: false

      t.timestamps null: false
    end
  end
end
