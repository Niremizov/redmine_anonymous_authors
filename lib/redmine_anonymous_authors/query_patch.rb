module RedmineAnonymousAuthors
  module QueryPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :available_filters, :anonymous
      end
    end

    module InstanceMethods
      def available_filters_with_anonymous
        return @available_filters if @available_filters
        available_filters_without_anonymous
        if @available_filters["author_id"]
          anonymous = User.anonymous
          @available_filters["author_id"][:values] << [anonymous.name, anonymous.id.to_s]
        end
        @available_filters["author_name"] = { :type => :text, :order => 5, :name => l(:field_author_name) }
        @available_filters["author_mail"] = { :type => :text, :order => 5, :name => l(:field_author_mail) }
        @available_filters
      end

      def sql_for_author_name_field(field, operator, v)
        "(#{sql_for_field(field, operator, v, Issue.table_name, field)} OR #{Issue.table_name}.author_id IN " +
            "(SELECT id FROM #{User.table_name} WHERE #{sql_for_field(field, operator, v, User.table_name, "firstname")} " +
            "OR #{sql_for_field(field, operator, v, User.table_name, "lastname")}))"
      end

      def sql_for_author_mail_field(field, operator, v)
        "(#{sql_for_field(field, operator, v, Issue.table_name, field)} OR #{Issue.table_name}.author_id IN " +
            "(SELECT id FROM #{User.table_name} WHERE #{sql_for_field(field, operator, v, User.table_name, "mail")}))"
      end
    end
  end
end
