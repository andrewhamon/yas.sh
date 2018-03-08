class ApplicationController < ActionController::API
  before_action :authenticate

  include ActionController::HttpAuthentication::Token::ControllerMethods 


  private

  def authenticate
    @current_user = authenticate_or_request_with_http_token do |token, _| 
      User.exchange_token_for_user(token)
    end
  rescue
    render_unauthorized("Invalid token")
  end

  def current_user
    @current_user
  end

  def render_unauthorized(message)
    render json: {
      error: message
    }, status: :unauthorized
  end

  def render_json(object, root:, status: :ok, **opts)
    opts[:context] ||= current_user
    render json: {root => object.as_json(opts)}, status: status 
  end

  def render_errors(object, opts={})
    status = opts.delete :status do :unprocessable_entity end
    render json: JSONAPI::Serializer.serialize_errors(object.errors), status: status
  end
end
