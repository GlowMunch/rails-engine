class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def destroy
    render json: ItemSerializer.new(Item.destroy(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update
    render json: ItemSerializer.new(Item.update!(params[:id], item_params))
  end

  def find_all

    if params[:name].present?
      items =  Item.where("name ILIKE ?", "%#{params[:name]}%")
      render json: ItemSerializer.new(items)
    elsif params[:min_price].present?
      price = params[:min_price].to_i

      if price > 0
        min_value = 0
        items = Item.where("unit_price >= ? AND unit_price <= ?", min_value, price)

        render json: ItemSerializer.new(items)
      else
        null
      end
    else
      null
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end