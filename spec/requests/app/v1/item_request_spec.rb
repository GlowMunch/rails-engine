require "rails_helper"

RSpec.describe "Item requests" do
  before(:each) do
    @merchant1 = FactoryBot.create(:merchant)
    @merchant2 = FactoryBot.create(:merchant)
  end
  describe "Get /api/v1/items" do
    it "returns all items" do
      create_list(:item, 10, merchant_id: @merchant1.id)
      create_list(:item, 10, merchant_id: @merchant2.id)

      get "/api/v1/items"
      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(20)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_a(Integer)
        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    describe "Get /api/v1/items/item_id" do
      it "shows one item" do
        item1 = FactoryBot.create(:item, merchant_id: @merchant1.id)
        item_id = Item.first.id

        get "/api/v1/items/#{item_id}"
        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to have_key(:id)
        expect(item[:data]).to have_key(:type)
        expect(item[:data]).to have_key(:attributes)
      end
    end

    describe "CREATE /api/v1/items" do
      it "creates an item" do
        expect(Item.all.count).to eq(0)
        item_params = ({
          name: "Mother Mary's Choco-Wocco Chip Delight",
          description: "You Can't have just one",
          unit_price: 20.0,
          merchant_id: @merchant1.id,
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
        created_item = Item.last

        expect(response).to be_successful
        expect(Item.all.count).to eq(1)

          expect(created_item.name).to eq(item_params[:name])
          expect(created_item.description).to eq(item_params[:description])
          expect(created_item.unit_price).to eq(item_params[:unit_price])
          expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      end
    end

    describe "PATCH /api/v1/items/item_id" do
      it "updates an item" do
        item_id = FactoryBot.create(:item, merchant_id: @merchant1.id).id
        previous_name = Item.last.name
        item_params = { name: "Iphone 1000" }
        headers = {"CONTENT_TYPE" => "application/json"}

        # We include this header to make sure that these params are passed as JSON rather than as plain text
        patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: item_id)
        expect(response).to be_successful
        expect(item.name).to_not eq(previous_name)
        expect(item.name).to eq("Iphone 1000")
      end

      it "updates an item" do
        item_id = FactoryBot.create(:item, merchant_id: @merchant1.id).id
        previous_name = Item.last.name
        item_params = { name: "Iphone 1000", merchant_id: 99999999999 }
        headers = {"CONTENT_TYPE" => "application/json"}

        # We include this header to make sure that these params are passed as JSON rather than as plain text
        patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: item_id)
        expect(response).to_not be_successful
        expect(item.name).to eq(previous_name)
      end
    end

    describe "DELETE /api/v1/items/item_id" do
      it "deletes an item" do
        create_list(:item, 1, merchant_id: @merchant1.id)
        expect(@merchant1.items.count).to eq(1)
        delete "/api/v1/items/#{Item.first.id}"
        expect(@merchant1.items.count).to eq(0)
        expect{Item.find(@merchant1.items.first)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "Find /api/v1/items/item_id/merchant" do
      it "finds an items merchant" do
        item_id = FactoryBot.create(:item, merchant_id: @merchant1.id).id
        get "/api/v1/items/#{item_id}/merchant"

        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant[:data][:id].to_i).to eq(@merchant1.id)

      end
    end
  end
end