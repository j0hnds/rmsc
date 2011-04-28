module BuyersHelper
  def format_buyer_name(buyer)
    "#{buyer.last_name}, #{buyer.first_name}"
  end

  def store_options(stores)
    stores.collect { | store | [ format_the_store(store) , store.id ]}
  end

  private

  def format_the_store(store)
    "#{store.name} - #{store.address}, #{store.city}"
  end

end
