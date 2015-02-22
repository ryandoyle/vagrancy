require 'sinatra/base'
require 'vagrancy/filestore'

module Vagrancy
  class App < Sinatra::Base
    set :logging, true

    @filestore = Filestore.new()

    get '/:group/:box' do
      "return box info"
    end

    # Create a new box
    post '/api/v1/box/:group/:box' do
      box = JSONBoxAdapter.new(params[:name], params[:group], request.body.read).new_box
      box.save
    end

    # Create a new version
    post '/api/v1/box/:group/:box/:version' do
      
    end

    # Create a provider for the version
    post '/api/v1/box/:group/:box/:version/:provider' do

    end

    # Upload the box file to this version
    post '/api/v1/box/:group/:box/:version/:provider/box' do

    end

  end
end
