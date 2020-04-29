class Users::PasswordsController < ApplicationController
  def create
    resource = User.find_by(email: params[:email])
    if resource.present?
      resource.generate_password_token!
      UserMailer.reset_password_instruction(email: resource.email, reset_password_token: resource.reset_password_token)
                .deliver
    end

    render json: {
      success: true,
      message: "An email has been sent to '#{params[:email]}' containing instructions for resetting your password."
    }
  end

  def edit
    return redirect_to root_path, alert: 'Invalid Url' if params[:reset_password_token].blank?

    @resource = User.find_by(reset_password_token: params[:reset_password_token])

    return redirect_to root_path, alert: 'Invalid Url' if @resource.blank?
  end

  def update
    @resource = User.find(params[:id])
    if resource_params[:password] != resource_params[:password_confirmation]
      flash.now[:alert] = 'Password and password_confirmation mismatch.'
      return render :edit
    end

    @resource.reset_password!(resource_params[:password], resource_params[:password_confirmation])

    if @resource.errors.any?
      render :edit
    else
      redirect_to root_path, notice: 'Your password is successfully updated.'
    end
  end

  private

  def resource_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
