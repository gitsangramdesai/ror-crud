class Api::V1::ProductsController < ApplicationController
  def index
    products = Product.all
    render json:products,status:200
  end

  def create
    product = Product.new(
      name:params[:name],
      brand:params[:brand],
      price:params[:price],
      description:params[:description])

    if product.save
      render json:product,status:200
    else
      render json:{error:"Error creating product"}
    end
  end

  def show
    product = Product.find_by(id:params[:id])
    if product
      render json:product,status:200
    else
      render json:{error:"Product not found!"}
    end
  end

  def update
    product = Product.find_by(id:params[:id])

    product.name = params[:name]
    product.brand = params[:brand]
    product.price = params[:price]
    product.description = params[:description]

    if product.save
      render json:product,status:200
    else
      render json:{error:"Error Updating product"}
    end
  end

  def destroy
    if Product.destroy(params[:id])
      render json:{message:"Deleted Product"}
    else
      render json:{error:"Error Deleting product"}
    end
  end
  
end
