class ProjectsController < ApplicationController
  def create
    project = @current_user.projects.create(create_params)
    render json: project, status: :created
  end

  def show
    project = @current_user.projects.find(params[:id])

    if project
      render json: project, status: :ok
    else
      render status: :not_found
    end
  end

  private

  def create_params
    params.permit(
      :name
    )
  end
end
