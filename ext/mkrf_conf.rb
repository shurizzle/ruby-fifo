require 'rubygems'
require 'rubygems/command'
require 'rubygems/dependency_installer'

begin
    Gem::Command.build_args = ARGV
rescue NoMethodError
end

inst = Gem::DependencyInstaller.new

begin
    if RUBY_PLATFORM =~ /mswin/
        inst.install 'win32-pipe'
    else
        inst.install 'mkfifo'
    end
rescue
    exit(1)
end

f = File.open(File.join(File.dirname(__FILE__), 'Rakefile'), 'w')
f.write("task :default\n")
f.close
