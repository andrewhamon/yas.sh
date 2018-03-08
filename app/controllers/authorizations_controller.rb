class AuthorizationsController < ApplicationController
  skip_before_action :authenticate

  def create

    user = User.find_by!(email: auth_params[:username].to_s.downcase)

    token = user.exchange_password_for_token(auth_params[:password])

    render json: {
      access_token: token.access_token
    }, status: :created

    rescue
      render json: {
        error: "Invalid username or password"
      }, status: :unauthorized
  end

  def auth_params
    params.permit(:username, :password)
  end
end
