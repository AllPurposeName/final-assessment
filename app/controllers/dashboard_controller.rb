class DashboardController < ApplicationController
  def show
    user = current_user.user
    @new_user = user.pairings.where(paired_before: false).first.pair
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
