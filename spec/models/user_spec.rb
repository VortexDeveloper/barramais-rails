require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) { FactoryGirl.attributes_for :user }

  describe '#create' do
    context "with valid attributes" do
      it 'persists a user' do
        expect {
          user = User.create valid_attributes
        }.to change{ User.count }.by(1)
      end
    end

    context "with invalid attributes" do
      xit 'doesnt persist user' do

      end
    end
  end
end
