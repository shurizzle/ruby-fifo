require 'rubygems'

Gem::Specification.new {|s|
    s.name                  = 'ruby-fifo'
    s.version               = '0.1.0'
    s.author                = 'shura'
    s.email                 = 'shura1991@gmail.com'
    s.homepage              = 'http://github.com/shurizzle/ruby-fifo'
    s.platform              = Gem::Platform::RUBY
    s.required_ruby_version = '>= 1.9.2'
    s.summary               = 'A cross-platform library to use named pipe'
    s.description           = s.summary
    s.files                 = Dir['lib/*']
    s.require_path          = 'lib'
    s.has_rdoc              = true
    s.add_runtime_dependency 'mkfifo', '~> 0.1.1', '>= 0.1.1'
}
