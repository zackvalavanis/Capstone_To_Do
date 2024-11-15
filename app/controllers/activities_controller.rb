class ActivitiesController < ApplicationController
  def index
    if current_user
      @activities = Activity.all
      render :index
    else
      render json: { message: 'unauthorized' }
    end
  end

  def show
    @activity = Activity.find_by(id: params[:id])
    render :show
  end

  def create

    start_datetime_utc = Time.zone.parse(params[:start_datetime]).utc if params[:start_datetime].present?
    end_datetime_utc = Time.zone.parse(params[:end_datetime]).utc if params[:end_datetime].present?


    @activity = Activity.new(
      user_id: current_user.id,
      name: params[:name], 
      start_datetime: start_datetime_utc, 
      end_datetime: end_datetime_utc, 
      finished: params[:finished],
      time_zone: 'UTC'
    )
    if @activity.save
      render json: @activity, status: :created
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end
  
  def destroy 
    @activity = Activity.find_by(id: params[:id])

    if @activity.destroy
      render json: { message: 'Successfully Deleted'}
    else 
      render json: {message: 'nothing found or did not work'}
    end
  end 

  def update
    @activity = Activity.find_by(id: params[:id])
  
    # Check if activity exists
    if @activity
      # Parse datetime params if provided
      start_datetime_utc = Time.zone.parse(params[:start_datetime]).utc if params[:start_datetime].present?
      end_datetime_utc = Time.zone.parse(params[:end_datetime]).utc if params[:end_datetime].present?
  
      # Update activity attributes
      @activity.assign_attributes(
        name: params[:name] || @activity.name, 
        start_datetime: start_datetime_utc || @activity.start_datetime, 
        end_datetime: end_datetime_utc || @activity.end_datetime, 
        finished: params[:finished] || @activity.finished,
        time_zone: params[:time_zone] || @activity.time_zone
      )
  
      # Save the updated activity
      if @activity.save
        render json: @activity, status: :ok
      else
        render json: @activity.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'Activity not found' }, status: :not_found
    end
  end
  
end


# create_table "activities", force: :cascade do |t|
#   t.integer "user_id"
#   t.boolean "finished", default: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.string "name"
#   t.datetime "start_datetime", precision: nil, null: false
#   t.datetime "end_datetime", precision: nil, null: false
#   t.string "time_zone", default: "UTC"
# end