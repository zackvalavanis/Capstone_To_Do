class ActivitiesController < ApplicationController
  def index
    if current_user
      # Fetch activities for the logged-in user
      @activities = Activity.where(user_id: current_user.id)

      # Prepare data for FullCalendar (ISO 8601 format)
      activities_for_calendar = @activities.map do |activity|
        {
          id: activity.id,
          title: activity.name,
          start: activity.start_datetime.in_time_zone(current_user.time_zone).iso8601,
          end: activity.end_datetime.in_time_zone(current_user.time_zone).iso8601,
          description: activity.name,
          finished: activity.finished
        }
      end

      render json: activities_for_calendar
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def show
    @activity = Activity.find_by(id: params[:id])

    if @activity
      # Convert times to the user's local time zone for display
      @activity.start_datetime = @activity.start_datetime.in_time_zone(current_user.time_zone)
      @activity.end_datetime = @activity.end_datetime.in_time_zone(current_user.time_zone)
      render :show
    else
      render json: { error: 'Activity not found' }, status: :not_found
    end
  end

  def create
    logger.debug "Params received: #{params.inspect}"

    # Parse the date using Date.strptime to handle MM/DD/YYYY format
    begin
      date = Date.strptime(params[:date], "%m/%d/%Y")
    rescue ArgumentError => e
      logger.error "Date parsing error: #{e.message}"
      render json: { error: 'Invalid date format, please use MM/DD/YYYY' }, status: :bad_request
      return
    end

    # Parse the start and end datetimes using ISO 8601 format
    begin
      start_datetime = DateTime.parse(params[:start_datetime])
      end_datetime = DateTime.parse(params[:end_datetime])
    rescue ArgumentError => e
      logger.error "Datetime parsing error: #{e.message}"
      render json: { error: 'Invalid time format, please use ISO 8601 format' }, status: :bad_request
      return
    end

    # Convert datetimes to the user's time zone before saving
    start_datetime = start_datetime.in_time_zone(current_user.time_zone)
    end_datetime = end_datetime.in_time_zone(current_user.time_zone)

    # Create the activity record
    @activity = Activity.new(
      user_id: current_user.id,
      name: params[:name],
      date: date,
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      finished: params[:finished],
      time_zone: current_user.time_zone  # Store the time zone of the user
    )

    if @activity.save
      render :show, status: :created
    else
      render json: { error: @activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @activity = Activity.find_by(id: params[:id])

    if @activity
      logger.debug "Params for update: #{params.inspect}"

      # Parse date and time fields with error handling
      begin
        date = params[:date] ? Date.strptime(params[:date], "%m/%d/%Y") : @activity.date
      rescue ArgumentError => e
        logger.error "Invalid date format: #{e.message}"
        render json: { error: 'Invalid date format' }, status: :bad_request
        return
      end

      # Parse start and end datetime (ensure these are in the correct format)
      begin
        start_datetime = params[:start_datetime] ? DateTime.parse(params[:start_datetime]) : @activity.start_datetime
        end_datetime = params[:end_datetime] ? DateTime.parse(params[:end_datetime]) : @activity.end_datetime
      rescue ArgumentError => e
        logger.error "Invalid datetime format: #{e.message}"
        render json: { error: 'Invalid time format' }, status: :bad_request
        return
      end

      # Convert updated datetimes to local time zone
      start_datetime = start_datetime.in_time_zone(current_user.time_zone)
      end_datetime = end_datetime.in_time_zone(current_user.time_zone)

      # Attempt to update the activity with the new parameters
      if @activity.update(
        user_id: current_user.id,
        name: params[:name] || @activity.name,
        date: date || @activity.date,
        start_datetime: start_datetime || @activity.start_datetime,
        end_datetime: end_datetime || @activity.end_datetime,
        finished: params[:finished] || @activity.finished,
        time_zone: current_user.time_zone  # Keep the time zone consistent
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
