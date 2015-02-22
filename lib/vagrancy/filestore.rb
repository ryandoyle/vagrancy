require 'fileutils'

module Vagrancy
  class Filestore
  
    def initialize(base_path)
      @base_path = base_path
    end

    def exists?(file)
      File.exists? file
    end

    # Safely writes by locking
    def write(file, content)
      with_parent_directory_created(file) do 
        safely_write(file, content)
      end
    end


    private

    def with_parent_directory_created(file)
      base_directory = File.dirname("#{@base_path}#{file}")
      FileUtils.mkdir_p base_directory unless Dir.exists? base_directory
      yield
    end

    def safely_write(file, content)
      begin
        write_lock = File.open("#{@base_path}#{file}.lock", File::RDWR|File::CREAT, 0644)
        write_lock.flock(File::LOCK_EX)

        transaction_file = File.open("#{@base_path}#{file}.txn", File::RDWR|File::CREAT, 0644)
        transaction_file.write(content)
        transaction_file.flush
        FileUtils.mv(transaction_file.path, "#{@base_path}#{file}")
      ensure 
        transaction_file.close
        File.unlink("#{@base_path}#{file}.txn") if File.exists?("#{@base_path}#{file}.txn")
        write_lock.close
      end
    end

  end
end
