class PatchAuthorsController < ApplicationController
  before_action :set_patch_author, only: [:edit, :update, :destroy]

  def index
    @patch_authors = PatchAuthor.all
  end

  def new
    @patch_author = PatchAuthor.new
  end

  def edit
  end

  def create
    @patch_author = PatchAuthor.new(patch_author_params)

    if @patch_author.save
      flash[:success] = "登録しました"
      redirect_to action: 'index'
    else
      flash[:error] = "登録に失敗しました"
      render :new
    end
  end

  def update
    if @patch_author.update
      flash[:success] = "更新しました"
      redirect_to action: 'index'
    else
      flash[:error] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    if @patch_author.destroy
      flash[:success] = "#{@patch_author.name} を削除しました"
      redirect_to action: 'index'
    else
      flash[:error] = "削除に失敗しました"
      render :index
    end
  end

  private
    def set_patch_author
      @patch_author = PatchAuthor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patch_author_params
      params.fetch(:patch_author, {}).permit(:id, :name)
    end

end
