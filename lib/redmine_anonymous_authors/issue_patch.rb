module RedmineAnonymousAuthors
  module IssuePatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        validates_format_of :author_mail, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => true, multiline: true
        alias_method_chain :author, :anonymous
        alias_method_chain :author=, :anonymous
        alias_method_chain :visible?, :anonymous
      end
    end

    module InstanceMethods
      def author_with_anonymous
        author = author_without_anonymous
        if author && author.anonymous?
          author.name, author.mail = author_name, author_mail
        end
        author
      end

      def author_with_anonymous=(author)
        if author && author.anonymous?
          self.author_name, self.author_mail = author.name, author.mail
        else
          self.author_name = self.author_mail = nil
        end
        self.author_without_anonymous = author
      end

      def visible_with_anonymous?(usr=nil)
        usr ||= User.current
        visible_without_anonymous?(usr) || (usr.anonymous? && usr.mail == author_mail)
      end
    end
  end
end