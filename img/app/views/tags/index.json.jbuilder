json.array!(@tags) do |tag|
  json.extract! tag, :id, :str, :image_id
  json.url tag_url(tag, format: :json)
end
