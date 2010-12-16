class AnalysisController < ApplicationController
  def index
    @projects = Project.all
  end
  
  def show_pipelines
    logger params
  end
end
