class ProjectsController < ApplicationController
  def index
    projects = @current_user.projects
    render json: projects, status: :ok
  end

  def create
    project = @current_user.projects.create(create_params)
    render json: project, status: :created
  end

  def show
    project = @current_user.projects.find(params[:id])
    render json: project, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end

  def destroy
    project = @current_user.projects.find(params[:id])

    if project.destroy
      head :ok
    else
      response json: { errors: project.errors.full_messages },
        status: :unprocessible_entity
    end

  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end

  private

  def create_params
    params.permit(
      :name
    )
  end
end
