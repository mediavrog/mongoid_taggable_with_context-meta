require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "mongoid_taggable_with_context_with_meta"
  gem.homepage = "https://github.com/mediavrog/mongoid_taggable_with_context_with_meta"
  gem.license = "MIT"
  gem.summary = %Q{Attach meta information to tags}
  gem.description = %Q{It provides methods to add meta data to tags created with Mongoid Taggable with Context.}
  gem.email = "maik@mediavrog.net"
  gem.authors = ["Maik Vlcek"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = "--color --format progress"
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
