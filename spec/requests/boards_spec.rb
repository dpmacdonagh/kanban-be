require 'rails_helper'
require 'unauthenticated_crud_requests'

RSpec.describe 'Boards', :type => :request do
  include ApiHelper

  let!(:valid_create_params) do
    { title: 'Test Board' }
  end

  include_examples 'unauthenticated CRUD requests', {
    index: '/boards',
    create: '/boards/1',
    show: '/boards/1',
    update: '/boards/1',
    delete: '/boards/1'
  }

  context 'authenticated requests' do
    context 'index' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:user_board) { create(:board, valid_create_params.merge(user_id: user.id)) }
      let(:user2_board) { create(:board, valid_create_params.merge(user_id: user2.id)) }

      it 'returns the users boards' do
        user.boards.create!(valid_create_params)
        get '/boards', headers: authorize_header(user)
        user_boards = JSON.parse(response.body)

        expect(user_boards.count).to eq(1)
        expect(user_boards.first["user_id"]).to eq(user_board["user_id"])
      end
    end

    context 'create' do
      let(:user) { create(:user) }

      it 'returns a board belonging to the authed user' do
        post '/boards', params: valid_create_params, headers: authorize_header(user)
        board = JSON.parse(response.body)
        
        expect(board["title"]).to eq(valid_create_params[:title])
        expect(board["user_id"]).to eq(user.id)
      end
    end

    context 'show' do
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

    context 'update' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:user_board) { create(:board, valid_create_params.merge(user_id: user.id)) }
      let(:user2_board) { create(:board, valid_create_params.merge(user_id: user2.id)) }

      before do
        put "/boards/#{board_id}", params: params, headers: authorize_header(user)
      end

      context 'with a board_id belonging to the user' do
        let(:board_id) { user_board.id }
        let(:params) { { title: 'New Title' } }

        it 'returns the updated board' do
          expect(JSON.parse(response.body)["title"]).to eq(params[:title])
        end
      end

      context 'with a board_id not belonging to the user' do
        let(:board_id) { user2_board.id }
        let(:params) { { title: 'New Title' } }

        it 'returns not found' do
          expect(response).to be_not_found
          expect(user2_board.reload["title"]).not_to eq(params[:title]) 
        end
      end
    end

    context 'delete' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:user_board) { create(:board, valid_create_params.merge(user_id: user.id)) }
      let(:user2_board) { create(:board, valid_create_params.merge(user_id: user2.id)) }
  
      before do
        delete "/boards/#{board_id}", headers: authorize_header(user)
      end
  
      context 'with a board belonging to the user' do
        let(:board_id) { user_board.id }
  
        it 'deletes authed users board if it exists' do
          expect(response).to be_ok
          expect {user.boards.find(user_board.id)}.to raise_error(ActiveRecord::RecordNotFound)
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
end