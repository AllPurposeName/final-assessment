require "test_helper"

class BetterMatchSuggestionTest < ActiveSupport::TestCase

  def test_it_shows_pending_users_first
    simply_log_in
    all_user = User.find_by(name: "AllPurposeName")
    user = User.find_by(name: "worace")
    user.pairs << User.all
    user.pairings.where(pair_id: all_user.id).first.mark_as_interested
    user.save
    fill_in_description
    click_link("Find Pairs!")

    within("#name") do
      assert page.has_content?("worace"), "worace should be the first user displayed because he marked the current_user as interested"
    end
  end

  def test_if_no_users_are_pending_it_shows_users_in_regular_order
    find_pairs

    within("#name") do
      assert page.has_content?("worace"), "worace should happen before jcasimir"
    end
  end

  def simply_log_in
    visit "/"
    click_link("Login with GitHub")
  end

  def find_pairs
    visit "/"
    click_link("Login with GitHub")
    fill_in_description
    click_link("Find Pairs!")
  end

  def fill_in_description
    within("#information") do
      check("information[JavaScript]")
      check("information[Ruby]")
      check("information[Clojure]")
      click_button("Save Information")
    end
  end
end
