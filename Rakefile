require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'ffi-compiler/compile_task'

task :default => :spec

desc "run specs"
task :spec do
  RSpec::Core::RakeTask.new
end

FFI::Compiler::CompileTask.new('ext/geokdtree/geokdtree') do |c|
  c.have_library?('pthread')
end

CLEAN.include('ext/**/*{.o,.log,.so,.bundle}')
CLEAN.include('lib/**/*{.o,.log,.so,.bundle}')
CLEAN.include('ext/**/Makefile')

