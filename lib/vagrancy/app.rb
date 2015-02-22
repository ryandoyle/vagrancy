require 'sinatra/base'

require 'vagrancy/filestore'
require 'vagrancy/json_box_adapter'

module Vagrancy
  class App < Sinatra::Base
    set :logging, true


    get '/:group/:box' do
      "return box info"
    end

    # Create a new box
    post '/api/v1/box/:group/:box' do
      project_root = File.expand_path(File.dirname(__FILE__) + '/../../')
      @filestore = Filestore.new("#{project_root}/data/")
      box = JSONBoxAdapter.new(params[:box], params[:group], request.body.read, @filestore).new_box
      box.save
      status 201
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
