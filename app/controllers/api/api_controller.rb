class Api::ApiController < ActionController::Base
  before_action :set_default_format
  before_action :authenticate_token!

  def set_default_format
    request.format = :json
  end

  def authenticate_token!
    return if auth_token.nil? #TODO: need remove this later

    payload = JsonWebToken.decode(auth_token)
    @current_user = User.find(payload['sub'])
  rescue JWT::ExpiredSignature
    render json: { errors: ['Auth token has expired'] }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { errors: ['Invalid auth token'] }, status: :unauthorized
  end

  def auth_token
    @auth_token ||= request.headers.fetch('Authorization', '').split(' ').last
  end
end
