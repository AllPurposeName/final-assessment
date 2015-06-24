ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'minitest/pride'
require 'mocha'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  include Capybara::DSL
  fixtures :all
  config.include Rails.application.routes.url_helpers

  def setup
    user = User.find_by(name: "AllPurposeName")
    if user
      user.update!(description: nil)
    end
    ApplicationController.any_instance.mocha.stubs(:current_user).with(nil)
  end

  omniauth_hash =    {
    provider: "GitHub",
    uid: "9127698",
    login: "AllPurposeName",
    avatar_url: "https://avatars.githubusercontent.com/u/9127698?v=3",
    html_url: "https://github.com/AllPurposeName",
  }
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(omniauth_hash)
  OmniAuth.config.add_mock(:github, omniauth_hash)
  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }

  def login_user_with_description
    omniauth_hash =    {
      provider: "GitHub",
      uid: "9127698",
      login: "AllPurposeName",
      avatar_url: "https://avatars.githubusercontent.com/u/9127698?v=3",
      html_url: "https://github.com/AllPurposeName",
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(omniauth_hash)
    user = User.find_or_create_with_oauth(OmniAuth.config.mock_auth[:github])
    user.update!(description: "One wild and crazy guy.")

    ApplicationController.any_instance.mocha.stubs(:current_user).with(user)
  end

  def login_user
    omniauth_hash =    {
      provider: "GitHub",
      uid: "9127698",
      login: "AllPurposeName",
      avatar_url: "https://avatars.githubusercontent.com/u/9127698?v=3",
      html_url: "https://github.com/AllPurposeName",
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(omniauth_hash)

    ApplicationController.any_instance.mocha.stubs(:current_user).with(User.find_or_create_with_oauth(OmniAuth.config.mock_auth[:github]))
  end
end
