require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_it_is_created_with_github_oauth_info
    github_credentials = OpenStruct.new({provider: "github",
      uid: "9127698",
      login: "AllPurposeName",
      avatar_url: "https://avatars.githubusercontent.com/u/9127698?v=3",
      html_url: "https://github.com/AllPurposeName"})

    user = User.find_or_create_with_oauth(github_credentials)

    assert user.valid?
  end

  def test_it_builds_its_languages
    languages= {
      "JavaScript": 1,
      "Java": 0,
      "Ruby": 0,
      "Rust": 1   }

      user = User.create!
      user.languages << Language.all
      user.associate_languages(languages)

      assert_equal "Rust", user.user_languages.where(preferred: true).first.language.name
      assert_equal "JavaScript",          user.user_languages.where(preferred: true).second.language.name
      assert_equal "Clojure",       user.user_languages.where(preferred: false).first.language.name
      assert_equal "Ruby",       user.user_languages.where(preferred: false).second.language.name
  end
end
