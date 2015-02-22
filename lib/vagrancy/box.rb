require 'json'

module Vagrancy
  class Box

    def initialize(name, group, filestore, opts = {})
      @name = name
      @group = group
      @filestore = filestore
      @description = opts[:description]
      @short_description = opts[:short_description]
    end
    
    attr_reader :name, :group, :description, :short_description 

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

    def filename
      "#{@group}/#{@name}.json"
    end

    private 

    def to_json
      { 
        :description => "#{description}",
        :short_description => "#{short_description}",
        :name => "#{@group}/#{@name}",
        :versions => []
      }.to_json
    end

  end
end
