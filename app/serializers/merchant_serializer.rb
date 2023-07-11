class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  # has_many :invoice_items
  # has_many :items, through: :invoice_items

end
