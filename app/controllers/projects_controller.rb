class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = Project.new
  end

  def create
    response_message = ZillowEstimateService.new(project_params.merge(status: 'proposal')).create_prospect_and_estimate

    redirect_to new_project_path, notice: response_message
  end

  private

  def project_params
    params.require(:project).permit(:type_of_project, :address, :city, :state, :zip, :status, :user_id)
  end
end
