class ActivitiesController < ApplicationController
  def index
    if current_user
      @activities = Activity.where(user_id: current_user.id)
        render :index
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def show
    @activity = Activity.find_by(id: params[:id])
    if @activity
      # Convert times to local time for display
      @activity.start_datetime = @activity.start_datetime.in_time_zone(current_user.time_zone)
      @activity.end_datetime = @activity.end_datetime.in_time_zone(current_user.time_zone)
      render :show
    else
      render json: { error: 'Activity not found' }, status: :not_found
    end
  end

  def create
    logger.debug "Params received: #{params.inspect}"
    
    # Parse the date
    begin
      date = Date.strptime(params[:date], "%m/%d/%Y")
    rescue ArgumentError => e
      logger.error "Date parsing error: #{e.message}"
      render json: { error: 'Invalid date format' }, status: :bad_request
      return
    end
    
    # Log the received time parameters for debugging
    logger.debug "Start time received: #{params[:start_datetime]}"
    logger.debug "End time received: #{params[:end_datetime]}"
  
    # Try to parse the start and end datetime in 12-hour format first
    begin
      start_datetime = DateTime.strptime("#{params[:date]} #{params[:start_datetime]}", "%m/%d/%Y %I:%M %p")
      end_datetime = DateTime.strptime("#{params[:date]} #{params[:end_datetime]}", "%m/%d/%Y %I:%M %p")
    rescue ArgumentError => e
      logger.error "12-hour format parsing failed: #{e.message}"
      
      # If 12-hour format fails, try 24-hour format (HH:mm)
      begin
        start_datetime = DateTime.strptime("#{params[:date]} #{params[:start_datetime]}", "%m/%d/%Y %H:%M")
        end_datetime = DateTime.strptime("#{params[:date]} #{params[:end_datetime]}", "%m/%d/%Y %H:%M")
      rescue ArgumentError => e
        logger.error "24-hour format parsing failed: #{e.message}"
        render json: { error: 'Invalid time format' }, status: :bad_request
        return
      end
    end
  
    # Convert to local time before saving
    start_datetime = start_datetime.in_time_zone(current_user.time_zone)
    end_datetime = end_datetime.in_time_zone(current_user.time_zone)
  
    # Create the activity record
    @activity = Activity.new(
      user_id: params[:user_id],
      name: params[:name],
      date: date,
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      finished: params[:finished]
    )
    
    if @activity.save
      render :show, status: :ok
    else
      render json: { error: @activity.errors.full_messages }, status: :bad_request
    end
  end
  
  def update
    @activity = Activity.find_by(id: params[:id])

    if @activity
      date = params[:date] ? Date.strptime(params[:date], "%m/%d/%Y") : @activity.date
      start_datetime = params[:time_start] ? DateTime.strptime("#{params[:date]} #{params[:time_start]}", "%m/%d/%Y %I:%M %p") : @activity.start_datetime
      end_datetime = params[:time_end] ? DateTime.strptime("#{params[:date]} #{params[:time_end]}", "%m/%d/%Y %I:%M %p") : @activity.end_datetime

      # Convert updated datetimes to local time
      start_datetime = start_datetime.in_time_zone(current_user.time_zone)
      end_datetime = end_datetime.in_time_zone(current_user.time_zone)

      if @activity.update(
        user_id: current_user.id,
        name: params[:name] || @activity.name,
        date: date || @activty.date,
        start_datetime: start_datetime || @activity.start_datetime,
        end_datetime: end_datetime || @activity.end_datetime,
        finished: params[:finished] || @activity.finished
      )
        render json: @activity, status: :ok
      else
        render json: { error: @activity.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Activity not found' }, status: :not_found
    end
  end

  def destroy
    @activity = Activity.find_by(id: params[:id])

    if @activity
      @activity.destroy
      render json: { message: 'Activity has been deleted.' }, status: :ok
    else
      render json: { error: 'Activity not found' }, status: :not_found
    end
  end
end
