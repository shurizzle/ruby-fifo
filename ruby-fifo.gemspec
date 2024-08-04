require 'rubygems'

Gem::Specification.new {|s|
    s.name                  = 'ruby-fifo'
    s.version               = '0.2.0'
    s.author                = 'shura'
    s.email                 = 'shura1991@gmail.com'
    s.homepage              = 'http://github.com/shurizzle/ruby-fifo'
    s.platform              = Gem::Platform::RUBY
    s.required_ruby_version = '>= 1.9.2'
    s.summary               = 'A cross-platform library to use named pipe'
    s.description           = s.summary
    s.require_paths         = ['lib']
    s.has_rdoc              = true

    # exclude these files and directories from the gem
    dir_exclude  = Regexp.new(%r{^(test|spec|features)/})
    file_exclude = Regexp.new(/^(\.gitignore|\.travis|\.rubocop|\.rspec|Guardfile)/)
    excludes     = Regexp.union(dir_exclude, file_exclude)

    # add all files in the repository not matching any of the above
    s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(excludes) }
}
