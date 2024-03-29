class UsersController < ApplicationController
  skip_before_action :authorize_request, :only => [:create]
  
  def create
    @user = User.new(user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: @user, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages },
        status: :unprocessible_entity
    end
  end

  def current
    render json: @current_user, status: :ok
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
