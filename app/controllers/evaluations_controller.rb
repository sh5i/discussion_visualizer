require 'make_svg'

class EvaluationsController < ApplicationController
  include MakeSVG

  before_action :check_admin
  before_action :re_create_svg, only: [:show]

  def index
    @issues = Issue.all
  end

  def user_select
    @issue = Issue.find(params[:id])
    @users = @issue.users.distinct#.delete_if{|user| user.role == :admin}

    @results = Hash.new { |h,k| h[k] = {} }
    @users.each do |user|
      @results[user][:positive_edge], @results[user][:true_edge], @results[user][:true_positive],
      @results[user][:precision], @results[user][:recall], @results[user][:f_measure]     = get_evaluation_measure(@issue, user)
    end
  end

  def show
    @issue = Issue.find(params[:id])
    @user = User.find(params[:uid])

    @positive_edge, @true_edge, @true_positive, @precision, @recall, @f_measure = get_evaluation_measure(@issue, @user)
  end

  # 評価対象になる辺とその評価尺度(precision, recall, f_measure)を取得するメソッド
  # @param [Issue] 評価したいIssueオブジェクト
  # @param [user]  評価したいUserオブジェクト
  # @return [Array] ツール生成辺, ユーザー生成辺, ツールかつユーザー生成辺, precision, recall, f_measure の順に格納された配列
  def get_evaluation_measure(issue, user)
    machine = User.find_by(role: :admin)

    positive_edge = issue.edges.where(user_id: machine.id).select(:comment_id, :to_comment_id).distinct
    true_edge     = issue.edges.where(user_id: user.id).select(:comment_id, :to_comment_id).distinct
    true_edge.map{|e|e} #よくわからんけど、一回評価しないとdistinctが効かないみたい...?

    true_positive = []
    positive_edge.each do |p_edge|
      true_positive << true_edge.find_by(comment_id: p_edge.comment_id, to_comment_id: p_edge.to_comment_id)
    end
    true_positive.compact!

    precision = true_positive.size.fdiv(positive_edge.size)
    recall = true_positive.size.fdiv(true_edge.size)
    f_measure = 2 * recall * precision.fdiv(recall + precision)

    return positive_edge, true_edge, true_positive, precision, recall, f_measure
  end

  def check_admin
    redirect_to root_path if current_user.role != :admin
  end

  def re_create_svg
    @issue = Issue.find(params[:id])
    @user = User.find(params[:uid])
    create_svg(@issue, @user)
  end

end
