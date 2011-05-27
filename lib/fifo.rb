require 'forwardable'

begin
    begin
        require "win32/pipe"
        $POSIX = false
    rescue LoadError
        require 'mkfifo'
        $POSIX = true
    end
rescue LoadError
    raise LoadError, "No such file to load, please install 'win32/pipe' or 'mkfifo'"
end

class Fifo
    include Forwardable

    class ::File
        alias :owrite :write
        def write(*args)
            owrite(*args)
            flush
        end
    end

    def initialize(file, perms = :r, mode = :nowait)
        perms, mode = perms.to_s, mode.to_s
        raise "Unknown perms." unless %w{r w}.include?(perms)
        raise "Unknown mode." unless %w{wait nowait}.include?(mode)
        perms, mode = perms.to_sym, mode.to_sym
        if !$POSIX
            include Win32

            mode = {:wait => Pipe::WAIT, :nowait => Pipe::NOWAIT}[mode]
            @pipe = perms == :r ? Pipe.new_server(file, mode) : Pipe.new_client(file)
            @pipe.connect if perms == :r
        else
            if !File.exists?(file)
                File.mkfifo(file)
                File.chmod(0666, file)
            end
            @pipe = File.open(file, perms.to_s + {:wait => '', :nowait => '+'}[mode])
        end

        def_delegators :@pipe, :read, :write, :close, :to_io
    end

    def print(*args)
        args.each {|obj|
            self.write obj.to_s
        }
        write $\
    end

    def puts(*args)
        args.each {|obj|
            self.write "#{obj.to_s.sub(/\n$/, '')}\n"
        }
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
