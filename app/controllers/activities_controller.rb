class ActivitiesController < ApplicationController
  def index 
    if current_user
      @activities = Activity.where(user_id: current_user.id)
      if @activities.any? 
      render :index
      else 
        render json: { message: "No activities found"}, status: :ok
      end 
    else
      render json: { error: 'Unauthorized'}, status: :unauthorized
    end 
  end 

  def show 
    @activity = Activity.find_by(id: params[:id]);
    render :show
  end

  def create 
    @activity = Activity.new( 
      name: params[:name], 
      date: params[:date], 
      time_start: params[:time_start], 
      time_end: params[:time_end], 
      finished: params[:finished]
    )
    if @activity.save 
      render :show, status: :ok
    else 
      render json: {error: @activity.errors.full_messages}, status: :bad_request
    end 
  end 

  def update
    @activity = Activity.find_by(id: params[:id]);

    if @activity.update( 
      name: params[:name] || @activity.name, 
      date: params[:date] || @activity.date, 
      time_start: params[:time_start] || @activity.time_start, 
      time_end: params[:time_end] || @activity.time_end, 
      finished: params[:finished] || @activity.finished
    )
    render json: @activity, status: :ok
    else 
      render json: {error: @activity.errors.full_messages}, status: :unprocessable_entity
    end 
  end 

  def destroy
    @activity = Activity.find_by(id: params[:id]);

    if @activity
      @activity.destroy
      render json: { message: 'Activity has been deleted.'}, status: :ok
    else 
      render json: {error: @activity.errors.full_messages}, status: :not_found
    end 
  end 
end
