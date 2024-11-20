class HomepagesController < ApplicationController
  def index 
   render file: 'dist/index.html'
  end 
end
