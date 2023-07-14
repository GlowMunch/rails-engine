class Api::V1::MerchantsController < ApplicationController
  def index
    # render json: Merchant.all
    # render json: MerchantSerializer.new(Merchant.all.includes :items)
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    if params[:name] != ""
      name = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
      id = name.first.id
      render json: MerchantSerializer.new(Merchant.find(id))
    else
      render json: { message: "No Searach Content" }, status: 204
    end
  end

end