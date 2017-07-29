libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'forwardable'

if RUBY_PLATFORM =~ /mswin/
  require 'web32/pipe'
  $POSIX = false
else
  require 'mkfifo'
  $POSIX = true
end

require File.expand_path(File.join(libdir, 'ruby-fifo/fifo'))
