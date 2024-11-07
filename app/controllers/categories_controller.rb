class CategoriesController < ApplicationController
  def index 
    @categories = Category.all
    render :index
  end 

  def show 
    @category = Category.find_by(id: params[:id])
    if @category 
    render :show
    else 
      render json: { message: "The category does not exist"}
    end
  end 

  def create 
    @category = Category.new(
      category_type: params[:category_type], 
      activity_id: params[:activity_id]
    )
    if @category.save
      render :show
    else 
      render json: { error: @category.errors.full_messages}, status: :bad_request
    end 
  end

  def update
    @category = Category.find_by(id: params[:id])
    if @category.update(
      category_type: params[:category_type] || @category.category_type, 
      activity_id: params[:activity_id] || @category.activity_id
    )
    render :show 
    else 
      render json: { error: @category.errors.full_messages}, status: :bad_request
    end 
  end 

  def destroy 
    @category = Category.find_by(id: params[:id])
    if @category.destroy
      render json: { message: "The category has been deleted."}
    else 
      render json: { error: @category.errors.full_messages}, status: :bad_request
    end 
  end
end
