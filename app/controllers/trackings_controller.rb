class TrackingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @auctions = @user.tracked_auctions

    render 'trackings/index'
  end

  def create
    auction = Auction.find(params[:auction_id])

    tracking = Tracking.new(user: current_user, auction: auction)

    if tracking.save
      redirect_to auction_path(auction), notice: 'Auction tracked!'
    else
      redirect_to(
        auction_path(auction),
        alert: tracking.errors.full_messages.join(', ')
      )
    end
  end

  def destroy
    tracking = Tracking.find(params[:id])
    auction = tracking.auction

    if tracking.destroy
      redirect_to auction_path(auction), notice: 'Auction untracked'
    else
      redirect_to auction_path(auction),
        alert: tracking.errors.full_messages.join(', ')
    end
  end
end
