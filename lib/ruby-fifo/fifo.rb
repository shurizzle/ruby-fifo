class Fifo
  # Module to allow delegation
  include Forwardable

  # Constructs a new Fifo.
  def initialize(file, perms = :r, mode = :nowait)
    unless [:r, :w].include?(perms)
      raise "Unknown perms."
    end

    unless [:wait, :nowait].include?(mode)
      raise "Unknown mode."
    end

    if not $POSIX
      include Win32

      mode  = mode  == :wait ? Pipe::WAIT : Pipe::NOWAIT
      @pipe = perms == :r ? Pipe.new_server(file, mode) : Pipe.new_client(file)
      @pipe.connect if perms == :r
    else
      unless File.exists?(file)
        File.mkfifo(file)
        File.chmod(0666, file)
      end

      perms = perms.to_s + (mode == :wait ? '' : '+')
      @pipe = File.open(file, perms)
    end

    def_delegators :@pipe, :read, :write, :close, :to_io, :flush
  end

  def print(*args)
    args.each do |obj|
      self.write obj.to_s
    end

    write $OUTPUT_RECORD_SEPARATOR
    flush
  end

  def puts(*args)
    args.each do |obj|
      self.write "#{obj.to_s.sub(/\n$/, '')}\n"
    end

    flush
  end

  def getc
    self.read(1)
  end

  def readline
    str = ""
    while ($_ = self.read(1)) != "\n"
      str << $_
    end
    str << "\n"
  end

  def gets
    str = ""
    str << self.read(1) while !str.match(/#{Regexp.escape($/)}$/)
    str
  end
end
