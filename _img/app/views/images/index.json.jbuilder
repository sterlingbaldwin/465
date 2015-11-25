json.array!(@images) do |image|
  json.extract! image, :id, :filename, :private
  json.url image_url(image, format: :json)
end
