class HomepagesController < ApplicationController
  def index 
   render json:: { message: 'hello'}'
  end 
end
