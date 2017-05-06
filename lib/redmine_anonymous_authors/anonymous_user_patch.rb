module RedmineAnonymousAuthors
  module AnonymousUserPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :name, :anonymous
        alias_method_chain :mail, :anonymous
        alias_method_chain :mail=, :anonymous
        alias_method_chain :active?, :anonymous
        attr_writer :name
      end
    end

    module InstanceMethods
      def name_with_anonymous(*args)
        @name.presence || I18n.t(:label_user_anonymous)
      end
      def mail_with_anonymous
        email_address.try(:address)
      end
      def mail_with_anonymous=(arg)
        email = email_address || build_email_address
        email.address = arg
      end
      def active_with_anonymous?
        true
      end
    end
  end
end

