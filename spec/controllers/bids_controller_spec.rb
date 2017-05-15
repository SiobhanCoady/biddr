require 'rails_helper'

RSpec.describe BidsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { FactoryGirl.create(:auction, { user: user }) }
  let(:bid) { FactoryGirl.create(:bid, { auction: auction, user: user }) }

  describe '#create' do
    def valid_attributes(new_attributes = {})
      attributes = {
        amount: 20,
        date: Time.zone.now
      }
      attributes.merge(new_attributes)
    end

    context 'with user signed in' do
      before { request.session[:user_id] = user.id }
      it 'creates a bid in the database' do
        count_before = Bid.count
        bid = Bid.create(valid_attributes)
        count_after = Bid.count
        expect(count_after).to eq(count_before + 1)
      end
      it 'associates the bid with the signed-in user' do
        bid = Bid.create(valid_attributes({user_id: user.id}))
        expect(Bid.last.user).to eq(user)
      end
    end

    context 'with user not signed in' do
      it 'redirects to the sign in page' do
        post :create, params: {
          bid: FactoryGirl.attributes_for(:bid),
          auction_id: auction.id,
          user_id: user.id
        }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
