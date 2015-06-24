class CreateJoinTableUserLanguages < ActiveRecord::Migration
  def change
    create_table :user_languages, id: false do |t|
      t.integer :user_id
      t.integer :language_id
    end

    add_index :user_languages, :user_id
    add_index :user_languages, :language_id
  end
end
