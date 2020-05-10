class ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def render_errors(error)
    render json: { success: false, message: error }
  end
end
