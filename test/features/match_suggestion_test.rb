require "test_helper"

class MatchSuggestionTest < ActiveSupport::TestCase

  def test_there_is_a_find_pair_button_on_the_dashboard
    visit "/"
    click_link("Login with GitHub")
    fill_in_description



    assert_equal "/", current_path, "it redirects to dashboard/matches"
    assert page.has_link?("Find Pairs!")
    click_link("Find Pairs!")
    assert_equal "/dashboard", current_path
  end

  def test_a_potential_pairs_information_is_displayed
    find_pairs

    assert page.has_content?("User's github name"), "name should be displayed"
    assert page.has_content?("User's description"), "description should be displayed"
    assert page.has_content?("User's github profile pic"), "profile picture should be displayed"
    assert page.has_content?("User's list of desired languages"), "list of langs should be displayed"
  end

  def test_it_should_have_options_to_approve_or_disprove_the_match
    find_pairs

    within(".buttons") do
      assert page.has_button?("Approve!"), "a button for approve should show up"
      assert page.has_button?("Reject!"), "a button for reject should show up"
    end
  end

  def test_it_should_store_approved_pairings
    find_pairs
    user = User.find_by(name: "AllPurposeName")


    assert_difference("user.pairings.where(paired_before: true).count", 1) do
      assert_difference("user.pairings.where(paired_before: false).count", -1) do
        click_button("Approve!")
      end
    end

    flash = "Congrats #{all_user.name}, you and #{user.name} are a good match!"
    refute page.has_content?(flash), "a flash message SHOULD NOT appear indicating a completed match"
  end
  def test_it_should_store_approved_pairings
    find_pairs
    user = User.find_by(name: "AllPurposeName")

    assert_difference("user.pairings.where(paired_before: true).count", 1) do
      assert_difference("user.pairings.where(paired_before: false).count", -1) do
        click_button("Reject!")
      end
    end
  end

  def test_it_marks_pair_as_interested_when_approved
    find_pairs
    user = User.find_by(name: "AllPurposeName")


    assert_difference("user.pairings.where(interested: true).count", 1) do
        click_button("Approve!")
      end
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
