require "test_helper"

class AccountCreationSignInTest < ActiveSupport::TestCase

  def test_an_unauthenticated_user_can_login_with_github
    visit "/"
    within("#login") do
      assert page.has_link?("Login with GitHub"), "Page should at least have the login link"
      click_link("Login with GitHub")
    end

    assert_equal "/information", current_path, "login redirect leads to information page"
  end

  def test_a_user_can_fill_in_their_information
    description = "Hello my name is DJ, I love programming"
    visit "/"
    click_link("Login with GitHub")

    within("#information") do
      check("information[JavaScript]")
      check("information[Ruby]")
      check("information[Clojure]")
      fill_in("information[about]", with: description)
    end

    click_button("Save Information")

    user = User.find_by(name: "AllPurposeName")
    preferred_langs     = user.user_languages.where(preferred: true)
    not_preferred_langs = user.user_languages.where(preferred: false)

    assert_equal "/",          current_path, "it redirects to dashboard/matches"
    assert_equal "JavaScript",    preferred_langs.first.language.name
    assert_equal "Ruby",       preferred_langs.second.language.name
    assert_equal "Clojure", preferred_langs.third.language.name
    assert_equal "Rust",       not_preferred_langs.first.language.name, "Rust was not checked, so it should be in the preferred: false group"
    assert_equal description,  user.description, "description should also be updated"
  end
end
