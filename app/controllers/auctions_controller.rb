class AuctionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_auction, only: [:show, :update]

  def index
    # @auctions = Auction.where('aasm_state = ? OR aasm_state = ?', 'published', 'reserve_met').order(created_at: :desc)
    @auctions = Auction.all.order(created_at: :desc)
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = Auction.new auction_params
    @auction.user = current_user
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

  def update
    @auction.publish
    @auction.save
    redirect_to auction_path(@auction)
  end

  private

    def find_auction
      @auction = Auction.find params[:id]
    end

    def auction_params
    params.require(:auction).permit([:title, :details, :ends_on, :reserve_price])
  end
end
