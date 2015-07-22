require 'vagrancy/box'
require 'vagrancy/box_versions'
require 'vagrancy/box_version'
require 'vagrancy/provider_box'

module Vagrancy
  class ProviderHandler
    def initialize(name, username, version, provider, filestore, request)
      @name = name
      @username = username
      @version = version
      @provider = provider
      @filestore = filestore
      @request = request
    end

    def write(stream)
      provider_box.write(stream)
    end

    def read
      provider_box.read
    end

    def box_exists?
      provider_box.exists?
    end


    def provider_box
      @provider_box ||= build_provider_box
    end

    def build_provider_box
      box = Box.new(@name, @username, @filestore, @request)
      box_versions = BoxVersions.new(box, @filestore, @request)
      box_version = BoxVersion.new(@version, box_versions, @filestore, @request)
      ProviderBox.new(@provider, box_version, @filestore, @request)
    end

  end
end
