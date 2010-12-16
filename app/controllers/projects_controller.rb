class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @pipelines = Project.find(params[:id]).pipelines
    @duration = Project.find(params[:id]).duration
  end
end
