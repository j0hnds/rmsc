module BuyersHelper
  def format_buyer_name(buyer)
    "#{buyer.last_name}, #{buyer.first_name}"
  end
  def store_options(stores)
    stores.collect { | store | [ format_store(store) , store.id ]}
  end

end
