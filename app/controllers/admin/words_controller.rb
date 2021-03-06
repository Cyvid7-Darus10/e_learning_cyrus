class Admin::WordsController < ApplicationController
  before_action :authorized_user
  
  def index
    @category = Category.find_by_id(params[:category_id])
    @words = @category.words.paginate(page: params[:page], per_page: 9).order(created_at: :desc)
  end

  def new
    @category = Category.find_by_id(params[:category_id])
    @word = @category.words.new
    3.times do
      @word.choices.new
    end
  end

  def create
    @category = Category.find_by_id(params[:category_id])
    @word = @category.words.new(word_params)
    if @word.save
      flash[:success] = "Word is created successfully!"
      redirect_to admin_category_words_path(@category)
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find_by_id(params[:category_id])
    @word = Word.find(params[:id])
  end

  def update
    @category = Category.find_by_id(params[:category_id])
    @word = Word.find(params[:id])
    if @word.update(word_params)
      flash[:success] = "#{@word.content} is updated successfully!"
      redirect_to admin_category_words_path(@category)
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find_by_id(params[:category_id])
    @word = @category.words.find(params[:id])
    if @word && @word.destroy
      flash[:success] = "#{@word.content} is deleted successfully!"
    else
      flash[:danger] = "Word is not deleted!"
    end
    redirect_to admin_category_words_path(@category)
  end

  private
  def word_params
    params.require(:word).permit(:content, choices_attributes: [:id, :content, :is_correct])
  end
end
