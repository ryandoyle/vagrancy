require 'json'

module Vagrancy
  class Box

    def initialize(name, group, filestore)
      @name = name
      @group = group
      @filestore = filestore
    end
    
    attr_accessor :name, :group, :description, :short_description 

    def save
      raise 'box already exists' if exists?
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
