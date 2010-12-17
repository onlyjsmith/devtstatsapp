class PipelinesController < ApplicationController
  def show_staff
    @leader = Project.find(params[:id]).pipelines.last.lead
    @pipelines = Pipeline.find_all_by_lead(@leader, :select => 'DISTINCT project_id')
  end
  
  def unique_staff
    @staff = Pipeline.find(:all, :select => 'DISTINCT lead')
  end
  
  def show_successes
    @pipelines = Pipeline.where(:stage => '1')
  end

  def show_failures
    @pipelines = Pipeline.where(:stage => 'F')
  end
  
end
