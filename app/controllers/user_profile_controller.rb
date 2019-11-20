class UserProfileController < ApplicationController
    before_action :authenticate_user!

    def show
      user_profile = current_user

      render json: user_profile
    end

    
  end