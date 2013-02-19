require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :spec

desc "clean, make and run specsrkae"
task :spec do
  RSpec::Core::RakeTask.new
end

desc "compile C ext and FFI ext and copy objects into lib"
task :make => [:clean] do
  Dir.chdir("ext/geokdtree") do
    ruby jruby? ? "-Xcext.enabled=true extconf.rb" : "extconf.rb"
    sh "make"
  end
  cp "ext/geokdtree/geokdtree.bundle", "lib/"
end

CLEAN.include('ext/**/*{.o,.log,.so,.bundle}')
CLEAN.include('lib/**/*{.o,.log,.so,.bundle}')
CLEAN.include('ext/**/Makefile')

def jruby?
  !!(defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby')
end

