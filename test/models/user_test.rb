require 'test_helper'

class UserTest < ActiveSupport::TestCase

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

      assert_equal "JavaScript",    user.user_languages.where(preferred: true).first.language.name
      assert_equal "Rust",          user.user_languages.where(preferred: true).second.language.name
      assert_equal "Ruby",          user.user_languages.where(preferred: false).first.language.name
      assert_equal "Clojure",       user.user_languages.where(preferred: false).second.language.name
  end

  def test_it_can_tell_if_it_has_rejected_a_user
    refute User.first.has_rejected?(User.second)
    assert User.first.has_not_rejected?(User.second)

    User.first.pairings.first.mark_as_paired

    assert User.first.has_rejected?(User.second)
    refute User.first.has_not_rejected?(User.second)
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
    user = User.first
    user2 = User.second
    user.pairings.where(pair_id: user2.id).first
    .mark_as_completed
    user2.pairings.where(pair_id: user.id).first
    .mark_as_completed

    assert_equal user2, user.matches.first
    assert_equal user,  user2.matches.first
  end

  def test_it_can_tell_when_already_interested_in_a_pairing
    user = User.first
    user2 = User.second
    user.pairings.where(pair_id: user2.id).first
    .mark_as_interested

    pairing = user2.pairings.where(pair_id: user.id).first

    assert user.already_interested?(pairing)
  end
end
