class AnalysisController < ApplicationController
  def index
    @projects = Project.all
  end
  
  def show_pipelines
    log params
  end
end
