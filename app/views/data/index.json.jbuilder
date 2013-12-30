json.array!(@data) do |datum|
  json.extract! datum, :id, :topik, :keywords, :adalah, :oleh, :dimana, :bagaimana
  json.url datum_url(datum, format: :json)
end
