class ActivitiesController < ApiController
  # before_action :authenticate_user!

  def index
    activities = current_user.activities

    render json: activities, status: :ok
  end
end
