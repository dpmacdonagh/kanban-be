require 'rails_helper'

RSpec.describe 'Todos', :type => :request do
  include ApiHelper

  let!(:valid_create_params) do
    { title: 'Test Card' }
  end

  context 'with an unauthorized get request' do
    it 'returns unauthorized' do
      get '/boards/1/cards'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized get request' do
    let(:user) { create(:user) }
    let(:user_board) { create(:board, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_board) { create(:board, { user_id: user2.id }) }

    before do
      user_board.cards.create(valid_create_params)
      user2_board.cards.create(valid_create_params)
      get "/boards/#{board_id}/cards", headers: authorize_header(user)
    end

    context 'with a board_id belonging to the user' do
      let(:board_id) { user_board.id }

      it 'returns board cards' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
        expect(json.first["board_id"]).to eq(user_board.id)
      end
    end

    context 'with a board_id not belonging to the user' do
      let(:board_id) { user2_board.id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized create request' do
    it 'returns unauthorized' do
      post '/boards/1/cards', params: valid_create_params
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized create request' do
    let(:user) { create(:user) }
    let(:user_board) { create(:board, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_board) { create(:board, { user_id: user2.id }) }

    before do
      post "/boards/#{board_id}/cards", params: params, headers: authorize_header(user)
    end

    context 'with a board_id belonging to the user' do
      let(:board_id) { user_board.id }
      let(:params) { valid_create_params }

      it 'returns the card' do
        card = JSON.parse(response.body)
        expect(card["title"]).to eq(valid_create_params[:title])
      end
    end

    context 'with a board_id not belonging to the user' do
      let(:board_id) { user2_board.id }
      let(:params) { valid_create_params }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized show request' do
    it 'returns unauthorized' do
      get '/boards/1/cards/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized show request' do
    let(:user) { create(:user) }
    let(:user_board) { create(:board, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_board) { create(:board, { user_id: user2.id }) }

    before do
      get "/boards/#{board_id}/cards/#{card_id}", headers: authorize_header(user)
    end

    context 'with a card belonging to the user' do
      let(:board_id) { user_board.id }
      let(:card_id) { user_board.cards.create(valid_create_params).id }

      it 'returns the card' do
        card = JSON.parse(response.body)
        expect(card["title"]).to eq(valid_create_params[:title])
      end
    end

    context 'with a card not belonging to the user' do
      let(:board_id) { user2_board.id }
      let(:card_id) { user2_board.cards.create(valid_create_params).id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized delete request' do
    it 'returns unauthorized' do
      delete '/boards/1/cards/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized delete request' do
    let(:user) { create(:user) }
    let(:user_board) { create(:board, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_board) { create(:board, { user_id: user2.id }) }

    before do
      delete "/boards/#{board_id}/cards/#{card_id}", headers: authorize_header(user)
    end

    context 'with a card belonging to the user' do
      let(:board_id) { user_board.id }
      let(:card_id) { user_board.cards.create(valid_create_params).id }

      it 'returns ok' do
        expect(response).to be_ok
      end
    end

    context 'with a card not belonging to the user' do
      let(:board_id) { user2_board.id }
      let(:card_id) { user2_board.cards.create(valid_create_params).id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end
end