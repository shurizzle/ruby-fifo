FIFO
====

A simple library multiplatform to handle named pipe, works like File.

Reader Example:
    pipe = Fifo.new('/path/to/file') #non-blocking
    # OR
    # pipe = Fifo.new('/path/to/file', :r, :wait) #blocking

    pipe.read(2)
    pipe.getc
    pipe.gets
    pipe.readline

Writer Example:
    pipe = Fifo.new('/path/to/file', :w, :nowait) #non-blocking
    # OR
    # pipe = Fifo.new('/path/to/file', :w, :wait)

    pipe.write "HI"
    pipe.print "X"
    pipe.puts "OH", "HAI"
