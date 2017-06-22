require 'nokogiri'
require 'make_edge'
require 'make_svg'

class IssuesController < ApplicationController
  include MakeEdge
  include MakeSVG
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :update_svg, only: [:show]
  before_action :set_log, only: [:show, :new]

  # GET /issues
  # GET /issues.json
  def index
    if !params[:format]
      session[:project_id] = params[:format]
    end
    @project = Project.find_by(id: session[:project_id])
    @issues = Issue.where(project_id: @project)
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @edges = @issue.edges.where(user_id: current_user.id)
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)
    target_url = issue_params[:url].split('/')
    if target_url.include?("jira")
      xml_url = target_url[0..3]
      xml_url << ["si", "jira.issueviews:issue-xml", target_url[-1], target_url[-1]+"xml"]
      doc = Nokogiri::XML(open(xml_url.join("/")))

      @issue.title = doc.xpath('rss/channel/item/title').text
      _, @issue.name, project_name = *@issue.title.match(/\[((.*?)\-.*?)\]/)

      @project = Project.find_by(name: project_name)
      if @project.nil?
        @project = Project.new(name: project_name)
        @project.save
      end
      @issue.project = @project
      session[:project_id] = @project.id
      
      @issue.type_text = doc.xpath('rss/channel/item/type').text

      @duplicate_issue = Issue.find_by(url: @issue.url)
      if @duplicate_issue.nil?
        begin
          ActiveRecord::Base.transaction do
            @admin = User.find_by(role: :admin)
            @issue.save!
            create_comments(@issue, doc)
            create_edges(@issue.comments, @admin)
            create_edges(@issue.comments, current_user)
            create_svg(@issue, current_user)
          end
            flash[:success] = "課題の登録に成功"
            redirect_to @issue
          rescue => e
            logger.error "----ERROR----"
            logger.error e
            logger.error "----ERROR----"
            flash[:error] = "課題の登録に失敗"
            render :new
        end
      else
        flash[:error] = "登録済みでした"
        redirect_to new_issue_path
      end
    else
      flash[:error] = "JIRAのプロジェクトを指定してください"
      render :new
    end

  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issueが削除されました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.fetch(:issue, {}).permit(:url)
    end

    def set_log
      if Rails.env == 'production'
        action = action_name=="show" ? "show/"+params[:id].to_s : "new"
        @log = Log.create(user: current_user, action_name: action, controller_name: "Issue", actioned_at: DateTime.now)
      end
    end

    def create_comments(issue, xml)
      count=0
      Comment.transaction do
        @description = Comment.new(type_text: :description,
                                   issue: issue,
                                   author:  xml.xpath('rss/channel/item/reporter').attribute("username"),
                                   content: xml.xpath('rss/channel/item/description').text,
                                   internal_id: count)
        @description.save!
        count += 1
        xml.xpath('rss/channel/item/comments/comment').each do |cmt|
          @comment = Comment.new(issue: issue,
                                 author: cmt.attribute("author"),
                                 content: cmt.text,
                                 jira_id: cmt.attribute("id"),
                                 internal_id: count )
          @comment.save!
          @comment.set_tag(current_user)
          count += 1
        end

      end
      rescue => e
        return e
    end

    def update_svg
      @issue = Issue.find(params[:id])
      create_svg(@issue, current_user)
    end



end
