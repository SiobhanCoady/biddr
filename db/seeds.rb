10.times do
  User.create   first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.email,
                password_digest: '12345678'
end

25.times do
  user = User.all.sample
  Auction.create  title: Faker::Commerce.product_name,
                  details: Faker::Hipster.paragraph,
                  ends_on: Faker::Date.forward(90),
                  reserve_price: rand(500),
                  current_price: 1,
                  user_id: user.id
end


auctions = Auction.all

auctions.each do |auction|
  number = rand(25)
  4.times do
    user = User.all.sample
    auction.bids.create({
      amount: number,
      auction_id: auction.id,
      user_id: user.id,
      date: Time.zone.now
    })
    auction.update({
      current_price: Bid.last.amount
      })
    number += rand(20)
  end
end

puts "#{Auction.count} auctions created!"
puts "#{User.count} users created!"
puts "#{Bid.count} bids created!"
