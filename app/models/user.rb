class User < ActiveRecord::Base
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
    user
    end
  end

  def associate_languages(langs)
    langs.each do |lang, bool|
      if bool.zero?
      languages << Language.find_or_create_by(name: lang)
      else
      languages << Language.find_or_create_by(name: lang, preferred: true)
      end
    end
  end
end
