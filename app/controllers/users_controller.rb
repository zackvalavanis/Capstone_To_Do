class UsersController < ApplicationController
  def index 
    @users = User.all
    render :index
  end 

  def create
    time_zone = params[:time_zone] || "Central Time (US & Canada)"

    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      time_zone: time_zone 
    )
    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def destroy 
    @user = User.find_by(id: params[:id])
    if @user 
      @user.destroy 
      render json: { message: 'The user has been deleted'}, status: :ok
    else 
      render json: {message: 'User not found'}
    end
  end 
end
