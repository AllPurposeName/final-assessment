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
    @user = current_user.user
  end

  def update
    user = current_user.user
    pairing = user.pairings.where(pair_id: params[:pair_id]).first
    pairing.mark_as_paired
    other_user = User.find_by(id: pairing.pair_id)
    if approve_was_clicked && other_user.already_interested?(pairing)
      others_pairing = other_user.pairings.where(pair_id: user.id).first
      pairing.mark_as_completed
      others_pairing.mark_as_completed
      flash[:notice] = "Congrats #{user.name}, you and #{other_user.name} are a good match!"
    elsif approve_was_clicked
      pairing.mark_as_interested
    else
    end
    redirect_to :back
  end

  def approve_was_clicked
    params[:_method] == "put"
  end
end
