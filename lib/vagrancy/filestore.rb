require 'fileutils'

module Vagrancy
  class Filestore
  
    def initialize(base_path)
      @base_path = base_path
    end

    def exists?(file)
      File.exists?(file_path(file))
    end

    def file_path(file)
      return "#{@base_path}#{file}"
    end

    def directories_in(path)
      Dir.glob("#{@base_path}#{path}/*").select {|d| File.directory? d}.collect do |entry|
        File.basename entry
      end
    end

    # Safely writes by locking
    def write(file, content)
      with_parent_directory_created(file) do 
        transactionally_write(file, content)
      end
    end

    def read(file)
      File.read("#{@base_path}#{file}")
    end

    def delete(file)
      File.unlink("#{@base_path}#{file}")
    end


    private

    def with_parent_directory_created(file)
      base_directory = File.dirname("#{@base_path}#{file}")
      FileUtils.mkdir_p base_directory unless Dir.exists? base_directory
      yield
    end

    def transactionally_write(file, content)
      within_file_lock(file) do
        begin 
          transaction_file = File.open("#{@base_path}#{file}.txn", File::RDWR|File::CREAT, 0644)
          IO.copy_stream(content,transaction_file)
#          transaction_file.write(content)
          transaction_file.flush
          FileUtils.mv(transaction_file.path, "#{@base_path}#{file}")
        ensure
          transaction_file.close
          File.unlink("#{@base_path}#{file}.txn") if File.exists?("#{@base_path}#{file}.txn")
        end
      end
    end

    def within_file_lock(file)
      begin
        write_lock = File.open("#{@base_path}#{file}.lock", File::RDWR|File::CREAT, 0644)
        write_lock.flock(File::LOCK_EX)
        yield
      ensure 
        write_lock.close
        File.unlink("#{@base_path}#{file}.lock") if File.exists?("#{@base_path}#{file}.lock")
      end
    end

  end
end
