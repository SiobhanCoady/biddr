class BidsController < ApplicationController
  def create
    @auction = Auction.find(params[:auction_id])
    bid_params = params.require(:bid).permit(:amount)
    @bid = Bid.new(bid_params)
    @bid.auction = @auction
    @bid.date = Time.zone.now
    # @bid.user = current_user


    if @bid.save
      redirect_to auction_path(@auction), notice: 'Bid created!'
    else
      render '/auctions/show'
    end

  end
end
