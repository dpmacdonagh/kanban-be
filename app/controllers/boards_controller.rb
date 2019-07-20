class BoardsController < ApplicationController
  def index
    boards = @current_user.boards
    render json: boards, status: :ok
  end

  def create
    board = @current_user.boards.create(create_params)
    render json: board, status: :created
  end

  def show
    board = @current_user.boards.find(params[:id])
    render json: board, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end

  def destroy
    board = @current_user.boards.find(params[:id])

    if board.destroy
      head :ok
    else
      response json: { errors: board.errors.full_messages },
        status: :unprocessible_entity
    end

  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end

  private

  def create_params
    params.permit(
      :title
    )
  end
end
