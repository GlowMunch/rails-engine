require "rails_helper"

RSpec.describe "Merchants API" do
  describe "GET /api/v1/merchants" do
    it "returns all merchants" do
      create_list(:merchant, 3)
      get "/api/v1/merchants"

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_a(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "GET /api/v1/merchants/id" do
    it "returns one merchant" do

      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id].to_i).to be_a(Integer)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe "GET /api/v1/merchants/id/items" do
    it "returns a list of one merchant's items" do
      merchant1 = Merchant.create!
      merchant2 = Merchant.create!

      id = merchant2.id

      create_list(:item, 10, merchant_id: merchant1.id)
      create_list(:item, 1, merchant_id: merchant2.id)

      get "/api/v1/merchants/#{merchant2.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)


      expect(merchant_items).to have_key(:data)

      merchant_items[:data].each do |item|
        expect(item).to be_a(Hash)
        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq(merchant2.items[0].name)
        expect(item[:attributes][:description]).to eq(merchant2.items[0].description)
        expect(item[:attributes][:unit_price]).to eq(merchant2.items[0].unit_price)
        expect(item[:attributes][:merchant_id]).to eq(merchant2.items[0].merchant_id)
      end

    end
  end
end
