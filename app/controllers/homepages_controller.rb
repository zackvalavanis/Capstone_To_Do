class HomepagesController < ApplicationController
  def index 
    render json: { messsage: 'hello'}
  end 
end
