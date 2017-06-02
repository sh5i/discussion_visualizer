class AutoTagAuthorsController < ApplicationController
  before_action :set_auto_tag_author, only: [:edit, :update, :destroy]

  def index
    @auto_tag_authors = AutoTagAuthor.all
  end

  def new
    @auto_tag_author = AutoTagAuthor.new
  end

  def edit
  end

  def create
    @auto_tag_author = AutoTagAuthor.new(auto_tag_author_params)

    if @auto_tag_author.save
      flash[:success] = "登録しました"
      redirect_to action: 'index'
    else
      flash[:error] = "登録に失敗しました"
      render :new
    end
  end

  def update
    if @auto_tag_author.update
      flash[:success] = "更新しました"
      redirect_to action: 'index'
    else
      flash[:error] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    if @auto_tag_author.destroy
      flash[:success] = "#{@auto_tag_author.name} を削除しました"
      redirect_to action: 'index'
    else
      flash[:error] = "削除に失敗しました"
      render :index
    end
  end

  private
    def set_auto_tag_author
      @auto_tag_author = AutoTagAuthor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auto_tag_author_params
      params.fetch(:auto_tag_author, {}).permit(:id, :name)
    end

end
