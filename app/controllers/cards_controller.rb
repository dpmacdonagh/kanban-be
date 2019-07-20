class CardsController < ApplicationController
  before_action :set_board

  def index
    cards = @board.cards
    render json: cards, status: :ok
  end

  def create
    card = @board.cards.create(create_params)
    render json: card, status: :created
  end

  def show
    card = @board.cards.find(params[:id])
    render json: card, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def update
    card = @board.cards.find(params[:id])
    
    if card.update(update_params)
      render json: card, status: :ok
    else
      render json: { errors: card.errors.full_messages },
        status: :unprocessible_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end

  def destroy
    card = @board.cards.find(params[:id])

    if card.destroy
      head :ok
    else
      response json: { errors: card.errors.full_messages },
        status: :unprocessible_entity
    end

  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  private

  def create_params
    params.permit(
      :title
    )
  end

  def update_params
    params.permit(
      :title
    )
  end

  def set_board
    @board = @current_user.boards.find(params[:board_id]) if params[:board_id]
  rescue
    head :not_found
  end
end
