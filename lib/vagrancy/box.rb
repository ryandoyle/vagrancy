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
      filestore.save 
    end

    def exists?
      filestore.exists? "#{Vagrancy.data_path}/#{@group}/#{@name}.json"
    end

    def to_json_string
      "foops"
    end

    private

    def description
      raise 'description not set' unless @description
      @description
    end

    def short_description
      raise 'short_description not set' unless @short_description
      @short_description
    end

  end
end
