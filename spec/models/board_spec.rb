require 'rails_helper'

RSpec.describe Board, :type => :model do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      title: 'Title',
      user_id: user.id
    }
  end

  context 'Associations' do
    it 'should belong to a user' do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'should have many cards' do
      expect(described_class.reflect_on_association(:cards).macro).to eq(:has_many)
    end
  end

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(Board.new(valid_attributes)).to be_valid  
    end

    it 'is invalid without title' do
      expect(Board.new(valid_attributes.except(:title))).to be_invalid
    end

    it 'is invalid without user_id' do
      expect(Board.new(valid_attributes.except(:user_id))).to be_invalid
    end
  end
end