class Admin::CategoriesController < ApplicationController
  before_action :authorized_user

  def index
    @categories = Category.paginate(page: params[:page], per_page: 9).order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category was successfully created"
      redirect_to admin_categories_path
    else
      render "new"
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:success] = "Category was successfully updated"
      redirect_to admin_categories_path
    else
      render "edit"
    end
  end

  def destroy
    @category = Category.find_by_id(params[:id])
    if @category && @category.destroy
      flash[:success] = "Category was successfully deleted"
      redirect_to admin_categories_path
    else
      flash[:danger] = "Category was not deleted successfully."
    end
  end
  
  private
  def category_params
    params.require(:category).permit(:title, :description)
  end

  def correct_user
    if !current_user || !current_user.is_admin?
      flash[:danger] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
end
