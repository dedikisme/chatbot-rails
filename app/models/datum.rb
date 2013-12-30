class Datum
  include Mongoid::Document
  field :topik, type: String
  field :keywords, type: Array
  field :adalah, type: String
  field :kapan, type: Date
  field :oleh, type: String
  field :dimana, type: Array
  field :bagaimana, type: Array
  field :situs, type: String
  field :fitur, type: Array
  field :platform, type: Array
  field :type, type: String
  field :pekerjaan, type: String
  field :almamater, type: String
end

