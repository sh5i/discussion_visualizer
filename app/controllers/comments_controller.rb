class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :create_or_update]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_or_update
    @comment.update!(comment_params)
      flash['success'] = "更新を反映しました"
      redirect_to [@comment.issue, cid: @comment.jira_id]
    rescue => e
      logger.error "----ERROR----"
      logger.error e
      logger.error "----ERROR----"
      flash['error'] = "更新の反映に失敗"
      redirect_back(fallback_location: root_path)
  end

  def bookmark
    render json: {status: 'login required'} and return if current_user.blank?
    @comment = Comment.find(params[:id])
    if @comment.bookmarked_by?(current_user)
      @bookmark = @comment.bookmarks.find_by(comment_id: @comment.id, user_id: current_user.id)
      if @bookmark.destroy
        render json: {status: 'ok'}
      else
        render json: {status: 'failed'}
      end
    else
      @star = @comment.bookmarks.create(comment_id: @comment.id, user_id: current_user.id)
      if @star.persisted?
        render json: {status: 'ok'}
      else
        render json: {status: 'failed'}
      end
    end
  end

  def association
    @comment  = Comment.find_by(jira_id: params[:id])
    @comments = @comment.issue.comments
  end

  def tags
    @tags = Tag.where(content: params[:tag])
    @comments = Comment.where(id: @tags.pluck(:comment_id))
    render json: {tags: @tags, comments: @comments}
  end

  def autocomplete_tag
    tag_suggestions = Tag.autocomplete(params[:term]).pluck(:content)
    respond_to do |format|
      format.html
      format.json {
        render json: tag_suggestions
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.fetch(:comment, {}).permit(:id, tags_attributes: [:id, :content, :user_id, :_destroy], edges_attributes: [:to_comment_id, :id, :_destroy, :user_id, :type_text])
    end
end
