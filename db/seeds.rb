25.times do
  Auction.create  title: Faker::Commerce.product_name,
                  details: Faker::Hipster.paragraph,
                  ends_on: Faker::Date.forward(90),
                  reserve_price: rand(500)
end

puts "#{Auction.count} auctions created!"
