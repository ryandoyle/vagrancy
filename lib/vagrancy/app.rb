require 'sinatra/base'

require 'vagrancy/filestore'
require 'vagrancy/filestore_configuration'
require 'vagrancy/upload_path_handler'
require 'vagrancy/box'
require 'vagrancy/provider_box'
require 'vagrancy/dummy_artifact'
require 'vagrancy/helpers/param_sanitizer'

module Vagrancy
  class App < Sinatra::Base
    set :logging, true
    set :show_exceptions, :after_handler
    helpers Vagrancy::Helpers::ParamSanitizer

    error Vagrancy::Helpers::InvalidParameterName do
      status 400
      env['sinatra.error'].message
    end

    get '/:username/:name' do
      box = Vagrancy::Box.new(sanitised_param(:name), sanitised_param(:username), filestore, request)

      status box.exists? ? 200 : 404
      content_type 'application/json'
      box.to_json if box.exists?
    end

    put '/:username/:name/:version/:provider' do
      box = Vagrancy::Box.new(sanitised_param(:name), sanitised_param(:username), filestore, request)
      provider_box = ProviderBox.new(sanitised_param(:provider), sanitised_param(:version), box, filestore, request)

      provider_box.write(request.body)
      status 201
    end

    get '/:username/:name/:version/:provider' do
      box = Vagrancy::Box.new(sanitised_param(:name), sanitised_param(:username), filestore, request)
      provider_box = ProviderBox.new(sanitised_param(:provider), sanitised_param(:version), box, filestore, request)

      send_file filestore.file_path(provider_box.file_path) if provider_box.exists?
      status provider_box.exists? ? 200 : 404
    end

    delete '/:username/:name/:version/:provider' do
      box = Vagrancy::Box.new(sanitised_param(:name), sanitised_param(:username), filestore, request)
      provider_box = ProviderBox.new(sanitised_param(:provider), sanitised_param(:version), box, filestore, request)

      status provider_box.exists? ? 200 : 404
      provider_box.delete
    end

    # Atlas emulation, no authentication
    get '/api/v1/authenticate' do
      status 200
    end

    post '/api/v1/artifacts/:username/:name/vagrant.box' do
      content_type 'application/json'
      UploadPathHandler.new(sanitised_param(:name), sanitised_param(:username), request, filestore).to_json
    end

    get '/api/v1/artifacts/:username/:name' do
      status 200
      content_type 'application/json'
      DummyArtifact.new(params).to_json
    end

    def filestore 
      path = FilestoreConfiguration.new.path
      Filestore.new(path)
    end

  end
end
