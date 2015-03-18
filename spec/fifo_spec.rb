require 'spec_helper'

describe Fifo do
  let(:fifo_path) { 'spec/data/fifo' }
  before(:each)   { delete_data_dir }
  after(:each)    { delete_data_dir }

  # Nukes the spec/data directory.
  def delete_data_dir
    FileUtils.rm Dir['spec/data/*']
  end

  # Get a random path for a test fifo. Pretty much guaranteed to be unique as it
  # uses the time plus nanoseconds to name the file. Used because there were
  # strange dependencies between tests that used the same fifo name, as you
  # would sort of expect when file handles don't get closed for whatever reason.
  # It was playing hell with the blocking tests.
  def random_fifo_path
    "spec/data/#{Time.now.to_f}"
  end

  describe "Non Blocking" do
    let(:writer)    { Fifo.new fifo_path, :w }
    let(:reader)    { Fifo.new fifo_path, :r }

    after  { reader.close; writer.close }

    it 'should be writable and readable' do
      writer.puts "Hey!"
      reader.gets.should == "Hey!\n"
    end

    it 'should be writable and readable from another process' do
      writer.puts "Hey!"

      fork do
        reader.gets.should == "Hey!\n"
      end

      Process.wait
    end

    it 'should be writable from another process and readable' do
      fork do
        writer.puts "Hey!"
      end

      reader.gets.should == "Hey!\n"
    end

    it 'should be writable and readable multiple times' do
      writer.puts "Test 1"
      writer.puts "Test 2"
      writer.puts "Test 3"
      writer.puts "Test 4"
      writer.puts "Test 5"

      reader.gets.should == "Test 1\n"
      reader.gets.should == "Test 2\n"
      reader.gets.should == "Test 3\n"
      reader.gets.should == "Test 4\n"
      reader.gets.should == "Test 5\n"
    end

    it 'should be possible to use readline in place of gets' do
      writer.puts "Hey!"
      reader.readline.should == "Hey!\n"
    end

    it 'should be possible to get characters one by one' do
      writer.puts "12345"
      reader.read(1).should == "1"
      reader.read(1).should == "2"
      reader.read(1).should == "3"
      reader.read(1).should == "4"
      reader.read(1).should == "5"
    end

    it 'should be possible to use getc in place of read(1)' do
      writer.puts "12345"
      reader.getc.should == "1"
      reader.getc.should == "2"
      reader.getc.should == "3"
      reader.getc.should == "4"
      reader.getc.should == "5"
    end

    it 'should be possible to read multiple characters' do
      writer.puts "12345"
      reader.read(2).should == "12"
      reader.read(3).should == "345"
    end

    it 'should fail if the given file permission is incorrect' do
      lambda { Fifo.new(fifo_path, :incorrect_perm, :nowait) }.should raise_error
    end

    it 'should fail if the given file mode is incorrect' do
      lambda { Fifo.new(fifo_path, :r, :incorrect_mode) }.should raise_error
    end
  end

  describe "Blocking" do
    it 'should not block when both ends opened, read first' do
      path = random_fifo_path

      lambda do
        timeout(0.5) do
          fork do
            r = Fifo.new path, :r, :wait
            r.close
          end

          fork do
            w = Fifo.new path, :w, :wait
            w.close
          end

          Process.wait
        end
      end.should_not raise_error
    end

    it 'should not block when both ends opened, write first' do
      path = random_fifo_path

      lambda do
        timeout(0.5) do
          fork do
            w = Fifo.new path, :w, :wait
            w.close
          end

          fork do
            r = Fifo.new path, :r, :wait
            r.close
          end

          Process.wait
        end
      end.should_not raise_error
    end

    it 'should block when only write end is open' do
      lambda do
        timeout(0.5) do
          w = Fifo.new random_fifo_path, :w, :wait
          w.close
        end

      end.should raise_error(Timeout::Error)
    end

    it 'should block when only read end is open' do
      lambda do
        timeout(0.5) do
          r = Fifo.new random_fifo_path, :r, :wait
          r.close
        end

      end.should raise_error(Timeout::Error)
    end
  end
end
