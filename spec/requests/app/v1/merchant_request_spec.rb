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

  describe "GET /api/v1/merchants" do
    it "returns one merchant" do

      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to eq(id)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end
end