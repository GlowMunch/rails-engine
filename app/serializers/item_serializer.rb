class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id

end
# attribute :foo do |object|
#   "foo #{object.description}"
# end