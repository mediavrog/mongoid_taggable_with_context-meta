#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'mongoid'
require 'mongoid_taggable_with_context'
require 'mongoid_taggable_with_context-meta.rb'
require 'database_cleaner'

Mongoid::MONGODB_VERSION = "1.8.2"

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("mongoid_taggable_with_context_meta_test")
end