require "test_helper"

class CompletingMatchTest < ActiveSupport::TestCase

  def test_it_indicates_when_a_match_has_been_completed
    simply_log_in
    all_user = User.find_by(name: "AllPurposeName")
    user = User.find_by(name: "worace")
    user.pairs << User.all
    user.pairings.where(pair_id: all_user.id).first.mark_as_interested
    user.save
    fill_in_description
    click_link("Find Pairs!")
    click_button("Approve!")

    flash = "Congrats #{all_user.name}, you and #{user.name} are a good match!"
    assert page.has_content?(flash), "a flash message should appear with a congratulations"
  end

  def test_it_lists_completed_matches_on_the_dashboard
    visit "/"
    click_link("Login with GitHub")
    fill_in_description
    all_user = User.find_by(name: "AllPurposeName")
    user = User.find_by(name: "worace")
    user.pairs << User.all
    user.pairings.where(pair_id: all_user.id).first.mark_as_completed
    all_user.pairings.where(pair_id: user.id).first.mark_as_completed

    visit '/'

    within("#matches") do
    assert page.has_content?("worace"), "worace should be marked as completed"
    refute page.has_content?("jcasimir"), "jcasimir has not been completed yet"
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
