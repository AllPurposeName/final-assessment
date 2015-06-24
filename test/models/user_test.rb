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
      "C": 1   }

      user = User.create!
      user.associate_languages(languages)

      assert_equal "JavaScript", user.languages.where(preferred: true).first.name
      assert_equal "C",          user.languages.where(preferred: true).second.name
      assert_equal "Ruby",       user.languages.where(preferred: false).first.name
      assert_equal "Java",       user.languages.where(preferred: false).second.name
  end
end
