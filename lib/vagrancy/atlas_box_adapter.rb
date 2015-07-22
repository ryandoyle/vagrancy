require 'json'

require 'vagrancy/box'

module Vagrancy
  class AtlasBoxAdapter
    def initialize(body, filestore, request)
      @body = body
      @filestore = filestore 
      @request = request
    end

    def box
      Vagrancy::Box.new(name, username, @filestore, @request)
    end

    def username
      raise ArgumentError, 'username is not set' if json['artifact']['username'].to_s == ''
      json['artifact']['username']
    end

    def name
      raise ArgumentError, 'name is not set' if json['artifact']['name'].to_s == ''
      json['artifact']['name']
    end

    def json
      @json ||= JSON.parse(@body)
    end

  end

end
