require 'rails_helper'
require 'unauthenticated_crud_requests'

RSpec.describe 'Users', :type => :request do
  include ApiHelper

  context 'authenticated requests' do
    context 'current' do
      let(:user) { create(:user) }

      it 'returns the current user' do
        get "/users/current", headers: authorize_header(user)
        json = JSON.parse (response.body)
        
        expect(json["id"]).to eq(user.id)
      end
    end
  end
end