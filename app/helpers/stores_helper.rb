module StoresHelper
  def format_store_address(store)
    address = store.address
    address << "<br>#{store.city}, #{store.state} #{store.postal_code}"
  end
  def format_store(store)
    "#{store.name} - #{store.address}, #{store.city}"
  end
end
