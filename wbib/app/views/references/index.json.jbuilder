json.array!(@references) do |reference|
  json.extract! reference, :id, :url, :topic_id
  json.url reference_url(reference, format: :json)
end
