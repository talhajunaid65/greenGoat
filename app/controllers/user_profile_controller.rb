class UserProfileController < ApiController
    before_action :authenticate_user!

    def show
      user_profile = current_user

      render json: user_profile, serializer: UserProfileSerializer
    end

    
  end