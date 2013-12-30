class Chat
  include Mongoid::Document
  field :ip, type: String
  field :pesan, type: Hash
end
