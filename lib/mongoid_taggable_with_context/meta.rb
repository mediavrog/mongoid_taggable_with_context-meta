module Mongoid
  module TaggableWithContext
    module Meta
      extend ActiveSupport::Concern

      included do
        embeds_many :meta_tags, :as => :meta_tagable, :class_name => "Mongoid::TaggableWithContext::Meta::MetaTag"
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
            self.meta_tags.where(context: "#{tags_field}").collect{|i| [i.name, i.meta] }
          end

          def #{tags_field}_including_meta
            normal_tags = self.#{tags_field}_array - self.#{tags_field}_having_meta_array
            self.#{tags_field}_having_and_including_meta + normal_tags.collect{|i| [i, {}]}
          end

          # adds single meta enhanced tag
          def add_#{tags_field.to_s.singularize}_with_meta(tag_name, meta)
            self.meta_tags.create(:context => "#{tags_field}", :name => tag_name.strip, :meta => meta)
            self.#{tags_field}_array << tag_name
          end
          END
        end

      end
    end
  end
end