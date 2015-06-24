class InformationController < ApplicationController
  def show
  end

  def create
    user = current_user.user
    parse_params
    lang_ids = params[:information].keys[0..-2].map { |k, v| Language.find_by(name: k).id }
    user.user_languages.where(language_id: lang_ids).each { |ul| ul.update(preferred: true) }
    user.update!(description: params[:information][:about])
    redirect_to root_path
  end


  def parse_params
    params[:information].delete_if{|key, value| value == "0"}
  end
end
