require 'rails_helper'

RSpec.describe 'Projects', :type => :request do
  include ApiHelper

  let!(:valid_create_params) do
    { name: 'Test Project' }
  end

  context 'with an unauthorized create request' do
    it 'returns a 401 status' do
      post '/projects', params: valid_create_params
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized create request' do
    let(:user) { create(:user) }

    it 'returns a project belonging to the authed user' do
      post '/projects', params: valid_create_params, headers: authorize_header(user)
      project = JSON.parse(response.body)
      
      expect(project["name"]).to eq(valid_create_params[:name])
      expect(project["user_id"]).to eq(user.id)
    end
  end

  context 'with an unauthorized get request' do
    it 'returns a 401 status' do
      get '/projects'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized get request' do
    let(:user) { create(:user) }

    it 'returns the users projects' do
      user.projects.create!(valid_create_params)
      get '/projects', headers: authorize_header(user)
      user_projects = JSON.parse(response.body)

      expect(user_projects.count).to eq(1)
    end
  end

  context 'with an unauthorized show request' do
    it 'returns a 401 status' do
      get '/projects/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized show request' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user_project) { create(:project, valid_create_params.merge(user_id: user.id)) }
    let(:user2_project) { create(:project, valid_create_params.merge(user_id: user2.id)) }
    
    before do
      get "/projects/#{project_id}", headers: authorize_header(user)
    end
    
    context 'with a project_id belonging to the user' do
      let(:project_id) { user_project.id }
      
      it 'returns the project' do
        expect(JSON.parse(response.body)["user_id"]).to eq(user.id)
      end
    end
    
    context 'with a project_id that doesnt belong to the user' do
      let(:project_id) { user2_project.id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized delete request' do
    it 'returns 401 status' do
      delete '/projects/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized delete request' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user_project) { create(:project, valid_create_params.merge(user_id: user.id)) }
    let(:user2_project) { create(:project, valid_create_params.merge(user_id: user2.id)) }

    before do
      delete "/projects/#{project_id}", headers: authorize_header(user)
    end

    context 'with a project belonging to the user' do
      let(:project_id) { user_project.id }

      it 'should delete authed users project if it exists' do
        expect(response).to be_ok
      end
    end

    context 'with a project belonging to another user' do
      let(:project_id) { user2_project.id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end
end