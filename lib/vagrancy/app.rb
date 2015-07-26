require 'sinatra/base'

require 'vagrancy/filestore'
require 'vagrancy/upload_path_handler'
require 'vagrancy/box'
require 'vagrancy/provider_box'
require 'vagrancy/dummy_artifact'

module Vagrancy
  class App < Sinatra::Base
    set :logging, true


    get '/:username/:name' do
      box = Vagrancy::Box.new(params[:name], params[:username], filestore, request)

      status box.exists? ? 200 : 404
      content_type 'application/json'
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

    delete '/:username/:name/:version/:provider/box' do
      box = Vagrancy::Box.new(params[:name], params[:username], filestore, request)
      provider_box = ProviderBox.new(params[:provider], params[:version], box, filestore, request)

      status provider_box.exists? ? 200 : 404
      provider_box.delete
    end

    # Atlas emulation, no authentication
    get '/api/v1/authenticate' do
      status 200
    end

    post '/api/v1/artifacts/:username/:name/vagrant.box' do
      content_type 'application/json'
      UploadPathHandler.new(params[:name], params[:username], request, filestore).to_json
    end

    get '/api/v1/artifacts/:username/:name' do
      status 200
      content_type 'application/json'
      DummyArtifact.new(params).to_json
    end

    def filestore 
      project_root = File.expand_path(File.dirname(__FILE__) + '/../../')
      Filestore.new("#{project_root}/data/")
    end

  end
end
