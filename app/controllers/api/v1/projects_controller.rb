class Api::V1::ProjectsController < ApiController
  before_action :authenticate_user!, only: [:create]

  def index
    projects = Project.all
    render json: projects, status: :ok
  end

  def show
    project = Project.find(params[:id])

    render json: project, status: :ok
  end

  def create
    project = current_user.projects.new(project_params.merge(status: 'proposal'))
    project.save

    render_errors(project.errors.full_messages) && return if project.errors.any?

    render json: project, status: :created
  end

  def update
    project = Project.find(params[:id])

    project.update_attributes(project_params)


    render json: project, status: :ok
  end

  def destroy
    project = Project.find(params[:id])

    render_errors('Could not delete project') && return unless project.destroy
    render json: project, status: :ok
  end

  def zillow_flow
    response_message = ZillowEstimateService.new(project_params.merge(status: 'proposal')).create_prospect_and_estimate

    render json: { message: response_message }, status: :ok
  end

  def contact_us
    email = params[:email]
    query = params[:query]

    ProjectMailer.contact_us(email, query).deliver_now

    render json: {status: "success"}, status: :ok
  end

  private

  def project_params
    params.require(:project).permit(:type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date)
  end
end
