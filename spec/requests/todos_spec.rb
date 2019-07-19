require 'rails_helper'

RSpec.describe 'Todos', :type => :request do
  include ApiHelper

  let!(:valid_create_params) do
    { name: 'Test Todo' }
  end

  context 'with an unauthorized get request' do
    it 'returns unauthorized' do
      get '/projects/1/todos'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized get request' do
    let(:user) { create(:user) }
    let(:user_project) { create(:project, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_project) { create(:project, { user_id: user2.id }) }

    before do
      user_project.todos.create(valid_create_params)
      user2_project.todos.create(valid_create_params)
      get "/projects/#{project_id}/todos", headers: authorize_header(user)
    end

    context 'with a project_id belonging to the user' do
      let(:project_id) { user_project.id }

      it 'returns project todos' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
        expect(json.first["project_id"]).to eq(user_project.id)
      end
    end

    context 'with a project_id not belonging to the user' do
      let(:project_id) { user2_project.id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized create request' do
    it 'returns unauthorized' do
      post '/projects/1/todos', params: valid_create_params
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized create request' do
    let(:user) { create(:user) }
    let(:user_project) { create(:project, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_project) { create(:project, { user_id: user2.id }) }

    before do
      post "/projects/#{project_id}/todos", params: params, headers: authorize_header(user)
    end

    context 'with a project_id belonging to the user' do
      let(:project_id) { user_project.id }
      let(:params) { valid_create_params }

      it 'returns the todo' do
        todo = JSON.parse(response.body)
        expect(todo["name"]).to eq(valid_create_params[:name])
        expect(todo["project_id"]).to eq(user_project.id)  
      end
    end

    context 'with a project_id not belonging to the user' do
      let(:project_id) { user2_project.id }
      let(:params) { valid_create_params }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized show request' do
    it 'returns unauthorized' do
      get '/projects/1/todos/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized show request' do
    let(:user) { create(:user) }
    let(:user_project) { create(:project, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_project) { create(:project, { user_id: user2.id }) }

    before do
      get "/projects/#{project_id}/todos/#{todo_id}", headers: authorize_header(user)
    end

    context 'with a todo belonging to the user' do
      let(:project_id) { user_project.id }
      let(:todo_id) { user_project.todos.create(valid_create_params).id }

      it 'returns the todo' do
        todo = JSON.parse(response.body)
        expect(todo["name"]).to eq(valid_create_params[:name])
      end
    end

    context 'with a todo not belonging to the user' do
      let(:project_id) { user2_project.id }
      let(:todo_id) { user2_project.todos.create(valid_create_params).id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end

  context 'with an unauthorized delete request' do
    it 'returns unauthorized' do
      delete '/projects/1/todos/1'
      expect(response).to be_unauthorized
    end
  end

  context 'with an authorized delete request' do
    let(:user) { create(:user) }
    let(:user_project) { create(:project, { user_id: user.id }) }

    let(:user2) { create(:user) }
    let(:user2_project) { create(:project, { user_id: user2.id }) }

    before do
      delete "/projects/#{project_id}/todos/#{todo_id}", headers: authorize_header(user)
    end

    context 'with a todo belonging to the user' do
      let(:project_id) { user_project.id }
      let(:todo_id) { user_project.todos.create(valid_create_params).id }

      it 'returns ok' do
        expect(response).to be_ok
      end
    end

    context 'with a todo not belonging to the user' do
      let(:project_id) { user2_project.id }
      let(:todo_id) { user2_project.todos.create(valid_create_params).id }

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end
end