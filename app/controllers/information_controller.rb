class InformationController < ApplicationController
  def show
  end

  def create
    user = current_user.user
    user.languages.where(name: parse_params.keys).update_all(preferred: true)
    user.update!(description: params[:information][:about])
    redirect_to root_path
  end


  def parse_params
    params[:information].delete_if{|key, value| value == "0"}
  end
end
