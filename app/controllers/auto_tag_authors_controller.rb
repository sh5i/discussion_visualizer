class AutoTagAuthorsController < ApplicationController
  before_action :set_auto_tag_author, only: [:edit, :update, :destroy]

  def index
    @auto_tag_authors = AutoTagAuthor.where(project_id: session[:project_id])
    @auto_tag_authors ||= []
  end

  def new
    @auto_tag_author = AutoTagAuthor.new
  end

  def edit
  end

  def create
    #カンマ区切りの入力を配列にする
    names=auto_tag_author_params[:author_name].split(",")
    contents=auto_tag_author_params[:tag_content].split(",")
    #登録が全部成功したか？
    succeeded=true
    #eachでそれぞれの要素について回す
    names.each do |it_name|
      contents.each do |it_content|
        @auto_tag_author = AutoTagAuthor.new(author_name: it_name , tag_content: it_content)
        @auto_tag_author.project_id = session[:project_id]      
        if AutoTagAuthor.where(author_name: it_name , tag_content: it_content).count!=0 then
          next
        end
        if @auto_tag_author.save
          flash[:success] = "タグ"+it_name+":"+it_content+"を登録しました"
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


          #redirect_to action: 'index'
        else
          flash[:error] = "登録に失敗しました"
          succeeded=false;
          #render :new
        end
      end
    end
    if succeeded then
      redirect_to action: 'index'
    else
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
        Comment.where(issue_id: iss.id, author: oldAutoTagAuthor.author_name ).each do |com|
          Tag.where(comment_id: com.id , content: oldAutoTagAuthor.tag_content).each do |t|
            #対応するタグを削除
            #t.content=@auto_tag_author.tag_content    
            #t.save
            t.delete
          end
        end
      end
      #現在プロジェクトに含まれる全issueのコメントに対して更新後の自動タグ付けを行う
      Issue.where(project_id: session[:project_id]).each do |iss|
        Comment.where(issue_id: iss.id, author: @auto_tag_author.author_name ).each do |com|
          Tag.create!(user_id: current_user.id, comment_id: com.id, content: @auto_tag_author.tag_content , auto_tag_author_id: @auto_tag_author.id)
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
