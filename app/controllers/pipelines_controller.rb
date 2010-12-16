class PipelinesController < ApplicationController
  def show
    @leader = Project.find(params[:id]).pipelines.last.lead
    all_pipelines = Pipeline.find_all_by_lead(@leader)
    @pipelines = []
    all_pipelines.each do |check|
      if @pipelines.include?(check)
        then
      else
        @pipelines << check
      end
    end 
  end
end
