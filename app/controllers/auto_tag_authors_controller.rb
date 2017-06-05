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
    @auto_tag_author.project_id = session[:project_id]

    if @auto_tag_author.save
      flash[:success] = "登録しました"
      #追加した自動タグに基づいてタグを更新
      #プロジェクトを取得
      nowProject=Project.find(session[:project_id])

      #現在プロジェクトに含まれる全issueの該当コメントについてタグをつける
      Issue.where(project_id: session[:project_id]).each do |iss|
        Comment.where(issue_id: iss.id, author: @auto_tag_author.author_name).each do |com|
          #タグをつける
          com.set_auto_tag(current_user,@auto_tag_author)
        end
      end


      redirect_to action: 'index'
    else
      flash[:error] = "登録に失敗しました"
      render :new
    end
  end

  def update


    oldAutoTagAuthor=AutoTagAuthor.find(params["id"])
    if @auto_tag_author.update(auto_tag_author_params)
      #変更した自動タグに基づいてタグを更新
      #プロジェクトを取得
      nowProject=Project.find(session[:project_id])

      #現在プロジェクトに含まれる全issueの該当コメントについてタグを更新
      Issue.where(project_id: session[:project_id]).each do |iss|
        Comment.where(issue_id: iss.id, author: @auto_tag_author.author_name ).each do |com|
          Tag.where(comment_id: com.id , content: oldAutoTagAuthor.tag_content).each do |t|
            #コンテンツを変更
            t.content=@auto_tag_author.tag_content    
            t.save
          end
        end
      end



      flash[:success] = "更新しました"
      redirect_to action: 'index'
    else
      flash[:error] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    if @auto_tag_author.destroy
      flash[:success] = "#{@auto_tag_author.author_name} を削除しました"
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
      params.fetch(:auto_tag_author, {}).permit(:id, :author_name ,:tag_content)
    end

end
