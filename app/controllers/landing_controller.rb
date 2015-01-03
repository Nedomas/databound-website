class LandingController < ApplicationController
  def index
    User.first(User.count - 200).each(&:destroy) if User.count > 1200
  end

  def initial_code
    code = render_to_string("landing/initial_#{params[:file]}", layout: false)

    respond_to do |format|
      format.html { render plain: code }
    end
  end
end
