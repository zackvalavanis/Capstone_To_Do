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
    # Extract date, start time, and end time from params
    date = params[:date]
    start_time = params[:start_datetime]
    end_time = params[:end_datetime]
    time_zone = params[:time_zone] || "America/Chicago"  # Default time zone if not provided

    # Combine the date with the start and end time to form the full datetime string
    start_datetime_str = "#{date} #{start_time}"
    end_datetime_str = "#{date} #{end_time}"

    # Convert the datetime string to the correct timezone using Time.zone
    start_datetime = Time.zone.parse(start_datetime_str)
    end_datetime = Time.zone.parse(end_datetime_str)

    # Now we can create the activity with the properly formatted datetimes
    @activity = Activity.new(
      user_id: current_user.id,
      finished: params[:finished],
      name: params[:name],
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      time_zone: time_zone
    )

    if @activity.save
      render json: @activity, status: :created
    else
      render json: @activity.errors, status: :unprocessable_entity
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
#   t.string "time_zone", default: "America/Chicago"
# end
