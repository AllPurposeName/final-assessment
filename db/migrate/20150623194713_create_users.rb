class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :description
      t.string :name
      t.string :avatar_url
      t.string :html_url

      t.timestamps null: false
    end
  end
end
