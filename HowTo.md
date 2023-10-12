First Create application as follows


rails new apiStack --api --database=postgresql

In controller folder create api folder inside api folder create v1 folder

generate new controller for product

rails g controller api/v1/products index show --no-helper --no-assets --no-template-engine --no-test-framework


generate product model

rails g model product name:string brand:string price:string description:string --no-helper --no-assets --no-template-engine --no-test-framework

in db/seeds.rb add following


Product.create([
    {
        name:"Quite Comfort 35",
        brand:"Bose",
        price:"$279.99",
        description:"Wireless Bluetooth HeadPhone,Noise Cancelling,with Alexa voice control-black"
    }
])

create & run mibgration

rake db:create 
rake db:migrate

save seed data

rake db:seed


edit product controller as 

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

  def by_brand_name
    products = Product.where(brand:params[:name])
    if products
      render json:products,status:200
    else
      render json:{error:"Product not found!"}
    end
  end
  
end


In config/routes.rb edit as following

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources:products,only:[:index,:show,:create,:update,:destroy]
      get "products/brand/:name",to:"products#by_brand_name"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end


then run application as 


rails s


Test API CAlls as following
    a) GET ALL
    curl --location 'http://localhost:3001/api/v1/products/'

    b) Create Product
    curl --location 'http://localhost:3001/api/v1/products' \
    --header 'Content-Type: application/json' \
    --data '    {
            "name": "32 Inch LCD",
            "brand": "TOSHIBA",
            "price": "$500.00 USD",
            "description": "Amazing LCD"
        }'

    3) Find By Id
    curl --location 'http://localhost:3001/api/v1/products/2'

    4) Update Product

    curl --location --request PUT 'http://localhost:3001/api/v1/products/1' \
    --header 'Content-Type: application/json' \
    --data '{
            "name": "PS4.0",
            "brand": "Sony.0",
            "price": "$500.00 USD",
            "description": "NNextGen Gaming Console"
    }'

    5) Delete Product
    curl --location --request DELETE 'http://localhost:3001/api/v1/products/3'

    4) Find By brand
    curl --location 'http://localhost:3001/api/v1/products/brand/Bose'