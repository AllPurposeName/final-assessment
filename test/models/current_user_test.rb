require 'test_helper'

class CurrentUserTest < ActiveSupport::TestCase
  def test_it_has_a_starting_path_based_on_user
    nil_user  = CurrentUser.new(nil)
    real_user = CurrentUser.new(User.first)

    assert_equal "layouts/login_page", nil_user.starting_path
    assert_equal "layouts/main",       real_user.starting_path
  end

  def test_it_directs_to_the_correct_matches_path
    nil_user  = CurrentUser.new(nil)
    real_user = CurrentUser.new(User.first)

    assert_equal "layouts/empty",   nil_user.matches
    assert_equal "layouts/matches", real_user.matches
  end

end
