require 'vagrancy/box_version'
module Vagrancy
  class BoxVersions

    def initialize(parent, filestore, request)
      @parent = parent
      @filestore = filestore
      @request = request 
    end


    def to_a
       versions.collect { |v| v.to_h }
    end

    def path
      @parent.path
    end

    private 

    def versions
      @filestore.directories_in(path).collect do |version|
        BoxVersion.new(version, self, @filestore, @request)
      end
    end

  end
end
