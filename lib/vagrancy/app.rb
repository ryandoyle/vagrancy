require 'sinatra/base'

require 'vagrancy/filestore'
require 'vagrancy/atlas_box_adapter'
require 'vagrancy/upload_path_handler'
require 'vagrancy/box'
require 'vagrancy/provider_box'

module Vagrancy
  class App < Sinatra::Base
    set :logging, true


    get '/:username/:name' do
      box = Vagrancy::Box.new(params[:name], params[:username], filestore, request)

      status box.exists? ? 200 : 404
      box.to_json if box.exists?
    end

    put '/:username/:name/:version/:provider/box' do
      box = Vagrancy::Box.new(params[:name], params[:username], filestore, request)
      provider_box = ProviderBox.new(params[:provider], params[:version], box, filestore, request)

      provider_box.write(request.body.read)
      status 201
    end

    get '/:username/:name/:version/:provider/box' do
      box = Vagrancy::Box.new(params[:name], params[:username], filestore, request)
      provider_box = ProviderBox.new(params[:provider], params[:version], box, filestore, request)

      response.write(provider_box.read) if provider_box.exists?
      status provider_box.exists? ? 200 : 404
    end

    # Atlas emulation, no authentication
    get '/api/v1/authenticate' do
      status 200
    end

    post '/api/v1/artifacts' do
      box = AtlasBoxAdapter.new(request.body.read, filestore).box
      box.save
      status 201
    end

    post '/api/v1/artifacts/:username/:name/vagrant.box' do
      UploadPathHandler.new(params[:name], params[:username], request).to_json
    end

    get '/api/v1/artifacts/:username/:name' do
      box = Vagrancy::Box.new(params[:name], params[:username], filestore, request)

      status box.exists? ? 200 : 404
      box.to_json if box.exists?
    end

    def filestore 
      project_root = File.expand_path(File.dirname(__FILE__) + '/../../')
      Filestore.new("#{project_root}/data/")
    end

  end
end
