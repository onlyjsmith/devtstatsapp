class ProjectsController < ApplicationController
  def show
    @pipelines = Project.find(params[:id]).pipelines
    @duration = Project.find(params[:id]).duration
  end
end
