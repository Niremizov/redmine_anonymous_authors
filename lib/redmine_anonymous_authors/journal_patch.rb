module RedmineAnonymousAuthors
  module JournalPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        validates_format_of :user_mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
        alias_method_chain :user, :anonymous
        alias_method_chain :user=, :anonymous
      end
    end

    module InstanceMethods
      def user_with_anonymous
        user = user_without_anonymous
        if user && user.anonymous?
          user.name, user.mail = user_name, user_mail
        end
        user
      end

      def user_with_anonymous=(user)
        if user && user.anonymous?
          self.user_name, self.user_mail = user.name, user.mail
        else
          self.user_name = self.user_mail = nil
        end
        self.user_without_anonymous = user
      end
    end
  end
end