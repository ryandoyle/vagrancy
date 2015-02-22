require 'json'

require 'vagrancy/box'

module Vagrancy
  class JSONBoxAdapter

    def initialize(name, group, json_string, filestore)
      @name = name
      @group = group
      @json_string = json_string
      @filestore = filestore
    end

    def new_box
      Vagrancy::Box.new(@name, @group, @filestore, 
                        :description => description, 
                        :short_description => short_description)
    end

    private

    def description
      json['description'] or raise ArgumentError, 'description not set'
    end

    def short_description
      json['short_description'] or raise ArgumentError, 'short_description not set'
    end

    def json
      begin
        @json ||= JSON.parse(@json_string)
      rescue JSON::ParserError => e
        raise ArgumentError, "invalid json data #{e.message}"
      end
    end

  end
end
