class CodesController < ApplicationController
  databound do
    model :code
    columns :partial, :content

    permit(:read, :update, :destroy) { false }
  end
end
