json.array!(@chats) do |chat|
  json.extract! chat, :id, :ip, :pesan
  json.url chat_url(chat, format: :json)
end
