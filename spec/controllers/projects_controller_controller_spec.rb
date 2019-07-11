require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include ApiHelper

  let!(:valid_create_params) do
    { name: 'Test Project' }
  end

  describe 'POST #create' do
    context 'with unauthenticated user' do
      it 'returns unauthorized' do
        post :create, params: { name: 'Test project' }
        expect(response).to be_unauthorized
      end
    end

    context 'with authenticated user' do
      let(:user) { create(:user) }

      it 'returns created project scoped to authed user' do
        authorize_header(user)
        post :create, params: valid_create_params
        
        expect(JSON.parse(response.body)["name"]).to eq(valid_create_params[:name])
        expect(JSON.parse(response.body)["user_id"]).to eq(user.id)
      end
    end
  end
end
