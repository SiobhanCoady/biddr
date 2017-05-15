class AuctionsController < ApplicationController
  before_action :find_auction, only: [:show, :edit]

  def index
    @auctions = Auction.all
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = Auction.new auction_params
    # @auction.user = current_user
    if @auction.save
      flash[:notice] = 'Auction created!'
      redirect_to auction_path(@auction)
    else
      flash.now[:alert] = 'Please fix errors below'
      render :new
    end
  end

  def show
    @bid = Bid.new
    @bids = Bid.where(auction_id: @auction.id).order(date: :desc)
  end

  private

    def find_auction
      @auction = Auction.find params[:id]
    end

    def auction_params
    params.require(:auction).permit([:title, :details, :ends_on, :reserve_price])
  end
end