class ProjectsController < ApplicationController
  before_action :authorize_request

  def create
    @project = @current_user.projects.create(create_params)
    render json: @project, status: :created
  end

  private

  def create_params
    params.permit(
      :name
    )
  end
end
