json.array!(@stemmings) do |stemming|
  json.extract! stemming, :id, :type, :keywords, :ganti, :kodisi
  json.url stemming_url(stemming, format: :json)
end
