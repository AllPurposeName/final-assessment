class CurrentUser
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def starting_path
    if user
      "layouts/main"
    else
      "layouts/login_page"
    end
  end
end
