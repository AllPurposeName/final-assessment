class DashboardController < ApplicationController
  def show
    user = current_user.user
    new_user = User.all_except(user).find { |u| u.pairings.where(interested: true).first && user.has_not_rejected?(u) }
    if new_user
      @new_user = new_user
    else
      @new_user = user.pairings.where(paired_before: false).first.pair
    end
    render :show
  end


  def index
  end

  def update
    user = current_user.user
    new_user = user.pairings.where(pair_id: params[:pair_id]).first
    new_user.mark_as_paired
    if params[:_method] == "put"
      new_user.mark_as_interested
    end
    redirect_to :back
  end
end
