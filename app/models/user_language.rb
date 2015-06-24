class UserLanguage < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  def mark_as_preferred
    update(preferred: true)
  end
end
