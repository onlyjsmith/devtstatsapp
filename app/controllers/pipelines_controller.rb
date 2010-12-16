class PipelinesController < ApplicationController
  def show
    @leader = Project.find(params[:id]).pipelines.last.lead
    @pipelines = Pipeline.find_all_by_lead(@leader, :select => 'DISTINCT project_id')
  end
end
