require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { FactoryGirl.create(:auction, { user: user }) }
  let(:auction1) { FactoryGirl.create(:auction) }

  describe '#index' do
    it 'assigns a variable for all the auctions' do
      auction
      auction1
      get :index
      expect(assigns(:auctions)).to eq([auction, auction1])
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#new' do
    context 'with no user signed in' do
      it 'redirects the user to the log in page' do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'with user signed in' do
      before { request.session[:user_id] = user.id }

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end

      it 'assigns a new auction instance variable' do
        get :new
        expect(assigns(:auction)).to be_a_new(Auction)
      end
    end
  end

  describe '#create' do
    context 'with signed in user' do
      before { request.session[:user_id] = user.id }

      context 'with valid attributes' do
        def valid_request
          post :create, params: {
            auction: FactoryGirl.attributes_for(:auction)
          }
        end
        it 'creates a new auction in the database' do
          count_before = Auction.count
          valid_request
          count_after = Auction.count
          expect(count_after).to eq(count_before + 1)
        end

        it 'redirects to the auction show page' do
          valid_request
          expect(response).to redirect_to(auction_path(Auction.last))
        end

        it 'associates the created auction with the signed-in user' do
          valid_request
          expect(Auction.last.user).to eq(user)
        end

        it 'sets a flash message' do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context 'with invalid attributes' do
        def invalid_request
          post :create, params: {
                          auction:
                            FactoryGirl.attributes_for(:auction, title: nil)
                        }
        end
        it 'does not create a record in the database' do
          count_before = Auction.count
          invalid_request
          count_after = Auction.count
          expect(count_after).to eq(count_before)
        end
        it 'renders the new template' do
          invalid_request
          expect(response).to render_template(:new)
        end
      end
    end

    context 'with no signed in user' do
      it 'redirects to the sign in page' do
        post :create
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe '#show' do
    it 'assigns a variable for the auction given an id' do
      get :show, params: { id: auction.id }
      expect(assigns(:auction)).to eq(auction)
    end

    it 'renders the show template' do
      get :show, params: { id: auction.id }
      expect(response).to render_template(:show)
    end
  end

end
