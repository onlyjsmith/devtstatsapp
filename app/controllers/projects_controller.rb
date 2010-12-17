class ProjectsController < ApplicationController
  def index
    # @projects = Project.all
    all_projects = Project.all
    exclude = [11399]
    @projects = []
    all_projects.each do |a|
      @projects << a unless a.pipelines.blank?
    end
    # logger.info "@projects = "
    # logger.info @projects
  end

  def show
    @pipelines = Project.find(params[:id]).pipelines
    @duration = Project.find(params[:id]).duration
  end
end
