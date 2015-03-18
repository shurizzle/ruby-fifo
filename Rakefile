require 'rspec/core/rake_task'

task :default => [:test]

desc "Run all tests."
RSpec::Core::RakeTask.new(:test) do |t|
    t.rspec_opts = '-cfs'
end

desc "Opens up an irb session with the load path and library required."
task :console do
  exec "irb -I lib/ -r ./lib/ruby-fifo.rb"
end

desc "Alias for rake console."
task :c => [:console]
