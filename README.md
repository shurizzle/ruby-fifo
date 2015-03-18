# ruby-fifo

A small, simple library for using Fifos in Ruby. A Fifo is traditionally a Unix
idea that lets processes communicate by writing to and reading from a special
kind of file in the filesystem. More information on fifos can be found here:
[http://en.wikipedia.org/wiki/Named_pipe](http://en.wikipedia.org/wiki/Named_pipe).

# Installation

To install ruby-fifo, execute the following command at your terminal:

    $ gem install ruby-fifo

Being sure not to include the dollar sign. The dollar sign is simply convention
for denoting a terminal command.

# Usage

To use a fifo, you need both a reader and a writer (the POSIX standard does not
define the behaviour from using the same file handle as both a reader and a
writer so this library does not allow it).

Here's some example code that will simply write to a fifo and read from it, all
in the same process:

``` ruby
reader = Fifo.new('path/to/fifo', :r, :nowait)
writer = Fifo.new('path/to/fifo', :w, :nowait)

writer.puts "Hello, world!"
reader.gets
#=> "Hello, world!\n"
```

Notice that we pass in `:r` and `:w` for the reader and writer respectively.
Also, we have this `:nowait` symbol in there. This tells the library that we
don't want to use "blocking" fifos.

## Blocking vs Non-blocking

A blocking fifo will block the current thread of execution until the other end
is opened. For example, the following code will never finish executing:

``` ruby
reader = Fifo.new('path/to/fifo', :r, :wait)
writer = Fifo.new('path/to/fifo', :w, :wait)
```

The thread will be blocked after the first line and it will wait until the
writing end of the fifo is opened before allowing execution to continue. This
also works exactly the same way in reverse (if you opened the writer before the
reader).

The following code should work fine:

``` ruby
fork do
  reader = Fifo.new('path/to/fifo', :r, :wait)
  reader.gets
  #=> Eventually, this will return "Hello, fork!\n"
end

fork do
  writer = Fifo.new('path/to/fifo', :w, :wait)
  writer.puts "Hello, fork!"
end
```

### Non-blocking

Alternately, you can use non-blocking pipes. These pipes don't wait for the
other end to be open before doing there work. The following code will work just
fine all in the same process:

``` ruby
writer = Fifo.new('path/to/fifo', :w, :nowait)
writer.puts "Testing"

reader = Fifo.new('path/to/fifo', :r, :nowait)
reader.gets
#=> "Testing\n"
```

### Defaults

Because of this, non-blocking is the default type of fifo that this library will
create.

``` ruby
fifo = Fifo.new('path/to/fifo')
# This is a non-blocking reader by default
```

## Other methods for reading and writing

There are other forms of reading and writing that will be familiar to you if you
have used the Ruby File object:

``` ruby
reader = Fifo.new('path/to/fifo', :r, :nowait)
writer = Fifo.new('path/to/fifo', :w, :nowait)

writer.puts "Two", "Lines"
reader.gets
#=> "Two\n"
reader.gets
#=> "Lines\n"

writer.print "12345"
# reader.gets would block forever here, no new line
reader.getc
#=> "1"
reader.read(1)
#=> "2"
reader.read(3)
#=> "345"

# reader.read(1)
#=> Blocks until something is written

writer.print "Same as puts\n"
reader.readline
#=> "Same as puts\n"
```
