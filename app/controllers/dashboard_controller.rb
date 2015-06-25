class DashboardController < ApplicationController
  def show
    user      = current_user.user
    @new_user = user.secret_admirers.first || Pairing.infinite_potentials(user).first
    render :show
  end

  def index
    @user = current_user.user
  end

  def update
    user       = current_user.user
    other_user = User.find params['pair_id']
    pairing    = Pairing.for(user, other_user).decide(approval?).tap(&:save!)
    pairing.true_love? and flash[:notice] = "Congrats #{user.name}, you and #{other_user.name} are a good match!"
    redirect_to :back
  end

  private

  def approval?
    params[:_method] == "put"
  end
end
