require 'vagrancy/box_version'
module Vagrancy
  class BoxVersions

    def initialize(parent, filestore, request)
      @parent = parent
      @filestore = filestore
      @request = request 
    end


    def to_a
       versions.select{ |v| v.exists? }.collect { |v| v.to_h }
    end

    private 

    def versions
      @filestore.directories_in(@parent.path).collect do |version|
        BoxVersion.new(version, @parent, @filestore, @request)
      end
    end

  end
end
