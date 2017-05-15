class BidsController < ApplicationController
  before_action :authenticate_user!

  def create
    @auction = Auction.find(params[:auction_id])
    bid_params = params.require(:bid).permit(:amount)
    @bid = Bid.new(bid_params)
    @bid.auction = @auction
    @bid.date = Time.zone.now
    @bid.user = current_user

    if @bid.amount >= @auction.reserve_price
      @auction.meet_reserve
      @auction.save
    end

    if @bid.user.id == @auction.user_id
      redirect_to auction_path(@auction), alert: 'You cannot bid on your own auction'
    elsif @bid.amount <= @auction.current_price
      redirect_to auction_path(@auction), alert: 'Bid amount must be greater than current price'
    elsif @bid.save
      @auction.current_price = @bid.amount
      @auction.save
      redirect_to auction_path(@auction), notice: 'Bid created!'
    else
      render '/auctions/show'
    end
  end
end
