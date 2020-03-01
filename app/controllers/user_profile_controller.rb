class UserProfileController < ApiController
  before_action :authenticate_user!

  def show
    render json: current_user, serializer: UserProfileSerializer
  end
end
