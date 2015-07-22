require 'spec_helper'

require 'vagrancy/filestore'

describe Vagrancy::Filestore do 

  let(:base_path) { "/root/"}
  let(:filestore) { Vagrancy::Filestore.new(base_path) }
  let(:transaction_file) { double 'transaction_file' }
  let(:write_lock) { double 'transaction_file' }

  describe '#exists?' do
    it "delegates to File.exists?" do
      expect(File).to receive(:exists?).with('/root/file_that_doesnt_exist.txt').and_return false

      expect(filestore.exists?("file_that_doesnt_exist.txt")).to be false
    end
  end

  describe '#list' do
    it 'returns a list of contents of a directory' do
      allow(Dir).to receive(:glob).with('/root/dir/*').and_return ['/root/dir/1', '/root/dir/2']

      expect(filestore.list("dir")).to eq ['1', '2']
    end
  end

  describe '#read' do
    it 'delegates reads to File module' do
      expect(File).to receive(:read).with('/root/file.txt')

      filestore.read('file.txt')
    end
  end


  describe '#write' do
    
    describe 'parent directories' do

      before do 
        allow(filestore).to receive(:transactionally_write)
      end

      it 'created if required' do
        allow(Dir).to receive(:exists?).with('/root/somedir').and_return false
        expect(FileUtils).to receive(:mkdir_p).with('/root/somedir')

        filestore.write('somedir/thefile.txt', 'mycontent')
      end

      it 'not created if they already exist' do
        allow(Dir).to receive(:exists?).with('/root/somedir').and_return true
        expect(FileUtils).to_not receive(:mkdir_p)

        filestore.write('somedir/thefile.txt', 'mycontent')
      end
    end

    describe 'transactional writing' do
      before do
        allow(Dir).to receive(:exists?).with('/root').and_return true
        allow(FileUtils).to receive(:mv)
        allow(File).to receive(:unlink)
        allow(write_lock).to receive(:flock)
        allow(write_lock).to receive(:close)
        allow(transaction_file).to receive(:close)
        allow(transaction_file).to receive(:write)
        allow(transaction_file).to receive(:flush)
        allow(transaction_file).to receive(:path).and_return('/root/file.json.txn')
        allow(File).to receive(:open).with('/root/file.json.txn', File::RDWR|File::CREAT, 0644).and_return transaction_file
        allow(File).to receive(:open).with('/root/file.json.lock', File::RDWR|File::CREAT, 0644).and_return write_lock
      end

      it 'writes content to the transaction file' do
        expect(transaction_file).to receive(:write).with('mycontent')

        filestore.write('file.json', 'mycontent')
      end

      it 'locks the transaction via the write lock before writing' do
        expect(write_lock).to receive(:flock).with(File::LOCK_EX).ordered
        expect(transaction_file).to receive(:write).ordered
        
        filestore.write('file.json', 'mycontent')
      end

      it 'moves the transaction file over the top of the original file' do
        expect(FileUtils).to receive(:mv).with('/root/file.json.txn', '/root/file.json')

        filestore.write('file.json', 'mycontent')
      end

      it 'moves the transaction file within the lock' do
        expect(write_lock).to receive(:flock).ordered
        expect(FileUtils).to receive(:mv).with('/root/file.json.txn', '/root/file.json')
        expect(write_lock).to receive(:close).ordered

        filestore.write('file.json', 'mycontent')
      end

      it 'flushes the transaction file before moving over the original file' do
        expect(transaction_file).to receive(:flush).ordered
        expect(FileUtils).to receive(:mv).ordered

        filestore.write('file.json', 'mycontent')
      end

      it 'always closes the transaction file' do 
        allow(transaction_file).to receive(:write).and_raise 'some error'

        expect(transaction_file).to receive(:close)
        expect{filestore.write('file.json', 'mycontent')}.to raise_error
      end

      it 'always removes the transaction file if it exists' do
        allow(transaction_file).to receive(:write).and_raise 'some error'
        allow(File).to receive(:exists?).with('/root/file.json.txn').and_return true
      
        expect(File).to receive(:unlink).with('/root/file.json.txn')
        expect{filestore.write('file.json', 'mycontent')}.to raise_error
      end

      it 'always closes the write lock' do
        allow(transaction_file).to receive(:write).and_raise 'error in cleanup'

        expect(write_lock).to receive(:close)
        expect{filestore.write('file.json', 'mycontent')}.to raise_error
      end

    end
  end

end
