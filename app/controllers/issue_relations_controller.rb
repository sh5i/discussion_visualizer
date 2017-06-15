class IssueRelationsController < ApplicationController
  before_action :set_issue_relation, only: [:show, :edit, :update, :destroy]

  # GET /issue_relations
  # GET /issue_relations.json
  def index
    @issue_relations = IssueRelation.all
  end

  # GET /issue_relations/1
  # GET /issue_relations/1.json
  def show
  end

  # GET /issue_relations/new
  def new
    @issue_relation = IssueRelation.new
  end

  # GET /issue_relations/1/edit
  def edit
  end

  # POST /issue_relations
  # POST /issue_relations.json
  def create
    @issue_relation = IssueRelation.new(issue_relation_params)

    respond_to do |format|
      if @issue_relation.save
        format.html { redirect_to @issue_relation, notice: 'Issue relation was successfully created.' }
        format.json { render :show, status: :created, location: @issue_relation }
      else
        format.html { render :new }
        format.json { render json: @issue_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_relations/1
  # PATCH/PUT /issue_relations/1.json
  def update
    respond_to do |format|
      if @issue_relation.update(issue_relation_params)
        format.html { redirect_to @issue_relation, notice: 'Issue relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_relation }
      else
        format.html { render :edit }
        format.json { render json: @issue_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_relations/1
  # DELETE /issue_relations/1.json
  def destroy
    @issue_relation.destroy
    respond_to do |format|
      format.html { redirect_to issue_relations_url, notice: 'Issue relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_relation
      @issue_relation = IssueRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_relation_params
      params.require(:issue_relation).permit(:issue_id, :target_issue_title, :target_issue_name, :type_text)
    end
end
