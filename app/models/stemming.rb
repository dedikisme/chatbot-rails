class Stemming
  include Mongoid::Document
  field :type, type: String
  field :keywords, type: String
  field :ganti, type: String
  field :kodisi, type: String
end
