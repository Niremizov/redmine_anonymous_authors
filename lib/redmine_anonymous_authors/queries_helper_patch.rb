module RedmineAnonymousAuthors
  module QueriesHelperPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :column_value, :anonymous
      end
    end

    module InstanceMethods
      def column_value_with_anonymous(column, issue, value)
        if value.class.name == 'AnonymousUser'
          link_to_user value
        else
          column_value_without_anonymous(column, issue, value)
        end
      end
    end
  end
end

