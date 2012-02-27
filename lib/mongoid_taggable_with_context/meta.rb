module Mongoid
  module TaggableWithContext
    module Meta
      extend ActiveSupport::Concern

      class MetaTag
        include Mongoid::Document
        field :name, :type => String
        field :context
        field :meta, :type => Hash, :default => {}
        embedded_in :meta_taggable, :polymorphic => true
      end

      included do
        embeds_many :taggable_meta_tags, :as => :meta_taggable, :class_name => "Mongoid::TaggableWithContext::Meta::MetaTag"
        set_callback :save,     :after, :update_taggable_meta_tags_on_save
      end

    end

    module ClassMethods
      alias_method :taggable_original, :taggable

      def taggable(*args)
        taggable_original(*args)

        options = args.extract_options!
        tags_field = (args.blank? ? :tags : args.shift).to_sym
        options = self.taggable_with_context_options[tags_field]

        # META Handling
        if options[:enable_meta]

          # instance methods
          class_eval <<-END

          # retrieve meta tags in various formats
          def #{tags_field}_having_meta
            self.#{tags_field}_having_meta_array.join(get_tag_separator_for(:"#{tags_field}"))
          end

          def #{tags_field}_having_meta_array
            self.#{tags_field}_having_and_including_meta.collect{|i| i[0]}
          end

          def #{tags_field}_having_and_including_meta
            self.taggable_meta_tags.where(context: "#{tags_field}").collect{|i| [i.name, i.meta] }
          end

          def #{tags_field}_including_meta
            normal_tags = self.#{tags_field}_array - self.#{tags_field}_having_meta_array
            self.#{tags_field}_having_and_including_meta + normal_tags.collect{|i| [i, {}]}
          end

          # adds single meta enhanced tag
          def add_#{tags_field.to_s.singularize}_with_meta(tag_name, meta)
            self.taggable_meta_tags.create(:context => "#{tags_field}", :name => tag_name.strip, :meta => meta)
            self.#{tags_field}_array << tag_name
            self.save!
          end
          END
        end

      end
    end

    protected

    def update_taggable_meta_tags_on_save
      tag_array_attributes.each do |context_array|
        next if changes[context_array].nil?

        old_tags, new_tags = changes[context_array]
        update_taggable_meta_tags(context_array, old_tags, new_tags)
      end
    end

    def update_taggable_meta_tags(context_array_field, old_tags=[], new_tags=[])
      context = context_array_to_context_hash[context_array_field]
      old_tags ||= []
      new_tags ||= []
      unchanged_tags  = old_tags & new_tags
      tags_removed    = old_tags - unchanged_tags
      self.taggable_meta_tags.where(context: context.to_s).any_in(name: tags_removed).delete_all
    end
  end
end