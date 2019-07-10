class ApplicationController < ActionController::API
  before_action :authorize_request
  
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue StandardError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
