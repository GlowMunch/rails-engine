require "rails_helper"

RSpec.describe "Search for Merchant and all it's items" do
  before(:each) do
    create_list(:merchant, 5)
    @merchant1 = FactoryBot.create(:merchant, name: "Crusty Crab")

    create_list(:item, 10, merchant_id: @merchant1.id)
    item1 = FactoryBot.create(:item, name: "Bubble Boat", merchant_id: @merchant1.id, unit_price: 1000 )
    item2 = FactoryBot.create(:item, name: "Big Boat", merchant_id: @merchant1.id, unit_price: 1111 )
    item3 = FactoryBot.create(:item, name: "Fun Boat", merchant_id: @merchant1.id, unit_price: 999 )
  end

  describe "Find one Merchant" do
    it 'can search through all Merchants and return via params' do
      search = "crusTy"
      get "/api/v1/merchants/find?name=#{search}"

      expect(response).to be_successful
      result = JSON.parse(response.body, symbolize_names: true)

    end
  end

  describe "Find all items by fragment" do
    it "finds all items by partial search" do
      search = "boat"
      get "/api/v1/items/find_all?name=#{search}"

      expect(response).to be_successful
      result = JSON.parse(response.body, symbolize_names: true)
    end
  end

  describe "Finds items by price" do
    it "searches by price" do

      price = 900
      get "/api/v1/items/find_all?min_price=#{price}"

      expect(response).to be_successful
      result = JSON.parse(response.body, symbolize_names: true)

    end
  end
end