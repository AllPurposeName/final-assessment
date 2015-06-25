class SwitchPairingsToStateMachine < ActiveRecord::Migration
  def change
    remove_column :pairings, :paired_before
    remove_column :pairings, :interested
    remove_column :pairings, :completed
    add_column :pairings, :state, :string, null: :false
  end
end
