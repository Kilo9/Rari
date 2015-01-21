json.array!(@cars) do |car|
  json.extract! car, :id, :model, :year, :price, :desc
  json.url car_url(car, format: :json)
end
