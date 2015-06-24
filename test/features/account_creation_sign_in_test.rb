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
    login_user
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
    assert_equal "/", current_path, "it redirects to dashboard/matches"
    assert_equal "Clojure", user.languages.where(preferred: true).first.name
    assert_equal "Ruby", user.languages.where(preferred: true).second.name
    assert_equal "JavaScript", user.languages.where(preferred: true).third.name
    assert_equal "Rust", user.languages.where(preferred: false).first.name, "Rust was not checked, so it should be in the preferred: false group"
    assert_equal description,  user.description, "description should also be updated"
  end
end
