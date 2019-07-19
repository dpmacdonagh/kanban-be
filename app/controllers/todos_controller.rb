class TodosController < ApplicationController
  before_action :set_project

  def index
    todos = @project.todos
    render json: todos, status: :ok
  end

  def create
    todo = @project.todos.create(create_params)
    render json: todo, status: :created
  end

  def show
    todo = @project.todos.find(params[:id])
    render json: todo, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def destroy
    todo = @project.todos.find(params[:id])

    if todo.destroy
      head :ok
    else
      response json: { errors: todo.errors.full_messages },
        status: :unprocessible_entity
    end

  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  private

  def create_params
    params.permit(
      :name
    )
  end

  def set_project
    @project = @current_user.projects.find(params[:project_id]) if params[:project_id]
  rescue
    head :not_found
  end
end
