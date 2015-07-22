require 'json'

require 'vagrancy/box_versions'

module Vagrancy
  class Box

    def initialize(name, group, filestore, request)
      @name = name
      @group = group
      @filestore = filestore
      @request = request
    end
    
    attr_reader :name, :group

    def save
      raise 'box already exists' if exists?
      @filestore.write(filename, to_json)
    end

    def update
      @filestore.write(filename, to_json)
    end

    def exists?
      @filestore.exists? filename 
    end

    def path
      "#{@group}/#{@name}"
    end

    def filename
      "#{path}/box.json"
    end

    def to_json
      { 
        :name => "#{@group}/#{@name}",
        :versions => BoxVersions.new(self, @filestore, @request).to_a
      }.to_json
    end

  end
end
