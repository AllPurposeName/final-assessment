class Pairing < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :pair, class_name: "User"

  def mark_as_paired
    update(paired_before: true)
  end

  def mark_as_interested
    update(interested: true)
  end

  def mark_as_completed
    update(completed: true)
  end
end
