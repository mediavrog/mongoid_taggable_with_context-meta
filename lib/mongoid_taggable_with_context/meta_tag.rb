module Mongoid::TaggableWithContext
  module Meta
    class MetaTag
      include Mongoid::Document
      field :name, :type => String
      field :context
      field :meta, :type => Hash, :default => {}
      embedded_in :meta_tagable, :polymorphic => true
    end
  end
end