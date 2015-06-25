class User < ActiveRecord::Base
  has_many :user_languages
  has_many :languages, through: :user_languages

  def self.find_or_create_with_oauth(github_hash)
    user = User.find_by(name: github_hash[:login])
    return user if user
    User.create!(name: github_hash[:login]) do |user|
      user.name       = github_hash[:login]
      user.avatar_url = github_hash[:avatar_url]
      user.html_url   = github_hash[:html_url]
      user.save

      user.languages = Language.all
    end
  end

  def self.all_except(user)
    User.where.not(id: user.id)
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

  def matches
    User.find_by_sql [
      'select * from users where
         (    id in (select user_id from pairings where pair_id = ? and state = "true_love")
           or id in (select pair_id from pairings where user_id = ? and state = "true_love")
         )
      ', id, id
    ]
  end

  def secret_admirers
    Pairing.includes(:user).where(state: 'secret_admirer', pair_id: id).map(&:user)
  end
end
