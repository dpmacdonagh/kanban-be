require 'rails_helper'

RSpec.describe Card, :type => :model do
  let(:user) { create(:user) }
  let(:board) { create(:board, { user_id: user.id })}
  let(:valid_attributes) do
    {
      title: 'Title',
      board_id: board.id
    }
  end

  context 'Associations' do
    it 'should belong to a board' do
      expect(described_class.reflect_on_association(:board).macro).to eq(:belongs_to)
    end
  end

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(Card.new(valid_attributes)).to be_valid  
    end

    it 'is invalid without title' do
      expect(Card.new(valid_attributes.except(:title))).to be_invalid
    end

    it 'is invalid without board_id' do
      expect(Card.new(valid_attributes.except(:board_id))).to be_invalid
    end
  end
end