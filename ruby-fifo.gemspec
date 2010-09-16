require 'rubygems'

Gem::Specification.new {|s|
    s.name          = 'ruby-fifo'
    s.version       = '0.0.1'
    s.author        = 'shura'
    s.email         = 'shura1991@gmail.com'
    s.homepage      = 'http://github.com/shurizzle/ruby-fifo'
    s.platform      = Gem::Platform::RUBY
    s.summary       = 'A cross-platform library to use named pipe'
    s.description   = s.summary
    s.files         = Dir['lib/*']
    s.extensions    = 'ext/mkrf_conf.rb'
    s.require_path  = 'lib'
    s.has_rdoc      = true
}
