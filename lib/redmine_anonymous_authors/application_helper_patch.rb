module RedmineAnonymousAuthors
  module ApplicationHelperPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :link_to_user, :anonymous
      end
    end

    module InstanceMethods
      def link_to_user_with_anonymous(user, options={})
        if user.is_a?(User) && user.anonymous?
          if User.current.anonymous? && Setting.plugin_redmine_anonymous_authors[:hide_anonymous_email] == '1' || user.mail.blank?
            h(user.name)
          else
            case Setting.plugin_redmine_anonymous_authors[:anonymous_format]
            when 'name'
              link_to_mail(user.mail, user.name, :title => user.mail)
            when 'email'
              link_to_mail(user.mail, nil, :title => user.name)
            else
              h("#{user.name} <") + link_to_mail(user.mail) + h(">")
            end
          end
        else
          link_to_user_without_anonymous(user, options)
        end
      end
    end
  end
end