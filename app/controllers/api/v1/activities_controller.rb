class Api::V1::ActivitiesController < ApiController
  before_action :authenticate_user!

  def index
    activities = current_user.activities.includes(:project)

    render json: activities, status: :ok
  end
end
