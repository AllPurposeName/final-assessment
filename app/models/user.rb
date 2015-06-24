class User < ActiveRecord::Base
  has_many :pairings
  has_many :pairs, through: :pairings, class_name: "User"
  has_many :user_languages
  has_many :languages, through: :user_languages

  def self.find_or_create_with_oauth(github_hash)
    user = User.find_by(name: github_hash[:login])
    if user
      user
    else
    user = User.create!(name: github_hash[:login])

    user.name       = github_hash[:login]
    user.avatar_url = github_hash[:avatar_url]
    user.html_url   = github_hash[:html_url]
    user.save

    user.languages << Language.all
    user.pairs << User.all
    user
    end
  end

  def self.all_except(user)
    User.all - [user]
  end

  def associate_languages(langs)
    langs.each do |lang, bool|
      if !bool.zero?
        lang_id = Language.find_by(name: lang).id
        user_lang = user_languages.where(language_id: lang_id, user_id: id).first
        if user_lang
          user_lang.mark_as_preferred
        end
      else
      end
    end
  end

  def preferred_languages
    user_languages.where(preferred: true).map(&:language)
  end

  def has_rejected?(user)
    pairings.where(pair_id: user.id).first.paired_before?
  end

  def has_not_rejected?(user)
    !has_rejected?(user)
  end

  def already_interested?(pairing)
    old_pairing =  pairings.where(pair_id: pairing.user_id).first
    old_pairing.interested? if old_pairing
  end

  def matches
    completed = pairings.where(completed: true)
    completed.map(&:pair) if completed
  end
end
