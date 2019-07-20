RSpec.shared_examples "unauthenticated CRUD requests" do |requests|
  context 'unauthenticated requests' do
    context 'index' do
      it 'returns unauthorized' do
        get requests[:index]
        expect(response).to be_unauthorized
      end
    end if requests[:index]
  
    context 'create' do
      it 'returns unauthorized' do
        get requests[:create]
        expect(response).to be_unauthorized
      end
    end if requests[:create]
  
    context 'show' do
      it 'returns unauthorized' do
        get requests[:show]
        expect(response).to be_unauthorized
      end
    end if requests[:show]
  
    context 'delete' do
      it 'returns unauthorized' do
        get requests[:delete]
        expect(response).to be_unauthorized
      end
    end if requests[:delete]
  end
end