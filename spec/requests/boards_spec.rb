require 'rails_helper'

RSpec.describe 'Boards', :type => :request do
  include ApiHelper

  let!(:valid_create_params) do
    { name: 'Test Board' }
  end

  context 'with an unauthorized create request' do
    it 'returns a 401 status' do
      post '/boards', params: valid_create_params
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized create request' do
    let(:user) { create(:user) }

    it 'returns a board belonging to the authed user' do
      post '/boards', params: valid_create_params, headers: authorize_header(user)
      board = JSON.parse(response.body)
      
      expect(board["name"]).to eq(valid_create_params[:name])
      expect(board["user_id"]).to eq(user.id)
    end
  end

  context 'with an unauthorized get request' do
    it 'returns a 401 status' do
      get '/boards'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized get request' do
    let(:user) { create(:user) }

    it 'returns the users boards' do
      user.boards.create!(valid_create_params)
      get '/boards', headers: authorize_header(user)
      user_boards = JSON.parse(response.body)

      expect(user_boards.count).to eq(1)
    end
  end

  context 'with an unauthorized show request' do
    it 'returns a 401 status' do
      get '/boards/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized show request' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user_board) { create(:board, valid_create_params.merge(user_id: user.id)) }
    let(:user2_board) { create(:board, valid_create_params.merge(user_id: user2.id)) }
    
    before do
      get "/boards/#{board_id}", headers: authorize_header(user)
    end
    
    context 'with a board_id belonging to the user' do
      let(:board_id) { user_board.id }
      
      it 'returns the board' do
        expect(JSON.parse(response.body)["user_id"]).to eq(user.id)
      end
    end
    
    context 'with a board_id that doesnt belong to the user' do
      let(:board_id) { user2_board.id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized delete request' do
    it 'returns 401 status' do
      delete '/boards/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized delete request' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user_board) { create(:board, valid_create_params.merge(user_id: user.id)) }
    let(:user2_board) { create(:board, valid_create_params.merge(user_id: user2.id)) }

    before do
      delete "/boards/#{board_id}", headers: authorize_header(user)
    end

    context 'with a board belonging to the user' do
      let(:board_id) { user_board.id }

      it 'should delete authed users board if it exists' do
        expect(response).to be_ok
      end
    end

    context 'with a board belonging to another user' do
      let(:board_id) { user2_board.id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end
end