require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_its_secret_admirers
    # is any pairing where state is secret_admirer and pair_id is the user
    User.transaction do
      me, p1, p2, p3 = User.create!, User.create!, User.create!, User.create!
      Pairing.create! user: me, pair: p1, state: 'secret_admirer'
      Pairing.create! user: p2, pair: me, state: 'secret_admirer'
      Pairing.create! user: me, pair: p3, state: 'infinite_potential'
      assert_equal [p2], me.secret_admirers
    end
  end

  def test_it_can_grab_all_users_minus_one
    collection = User.all_except(User.first)
    refute collection.include?(User.first)
  end

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

      assert_equal "Rust",       user.user_languages.where(preferred: true).first.language.name
      assert_equal "JavaScript", user.user_languages.where(preferred: true).second.language.name
      assert_equal "Clojure",    user.user_languages.where(preferred: false).first.language.name
      assert_equal "Ruby",       user.user_languages.where(preferred: false).second.language.name
  end


  def test_it_can_grab_its_preferred_languages
    user = User.first
    user.languages << Language.all
    lang = user.languages.first
    refute user.preferred_languages.first
    user.user_languages.where(language_id: lang.id).first.mark_as_preferred
    assert_equal user.languages.first, user.preferred_languages.first
  end

  def test_it_grabs_its_matches
    user  = User.first
    user2 = User.second
    Pairing.for(user, user2).like.like.save!

    assert_equal user2, user.matches.first
    assert_equal user,  user2.matches.first
  end
end
