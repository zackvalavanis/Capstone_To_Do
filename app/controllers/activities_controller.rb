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
    # Now we're directly accessing top-level params with permit
    @activity = Activity.new(
      user_id: current_user.id,
      finished: params[:finished],
      name: params[:name],
      start_datetime: params[:start_datetime],
      end_datetime: params[:end_datetime],
      time_zone: params[:time_zone] || "America/Chicago"  # Default if missing
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
