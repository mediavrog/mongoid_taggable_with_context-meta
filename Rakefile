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
  gem.name = "mongoid_taggable_with_context-meta"
  gem.homepage = "https://github.com/mediavrog/mongoid_taggable_with_context-meta"
  gem.license = "MIT"
  gem.summary = %Q{Attach meta information to tags}
  gem.description = %Q{It provides methods to enhance tags with meta data. Extension for gem mongoid_taggable_with_context}
  gem.email = "maik@mediavrog.net"
  gem.authors = ["Maik Vlcek"]
  gem.add_dependency 'mongoid_taggable_with_context'
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
