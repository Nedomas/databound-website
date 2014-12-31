class LandingController < ApplicationController
  def index
  end

  def initial_code
    code = render_to_string('landing/initial_code', layout: false)

    respond_to do |format|
      format.html { render plain: code }
    end
  end
end
