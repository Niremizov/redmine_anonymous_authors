module RedmineAnonymousAuthors
  module MailHandlerPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :dispatch, :anonymous
        alias_method_chain :create_user_from_email, :anonymous
      end
    end

    module InstanceMethods
      def dispatch_with_anonymous
        if user.anonymous?
          user.mail, user.name = from_address, from_name if from_address
        end
        dispatch_without_anonymous
      end

      def create_user_from_email_with_anonymous
        if from_address
          user = self.class.new_user_from_attributes(from_address, from_name)
          if user.save
            user
          else
            logger.error "MailHandler: failed to create User: #{user.errors.full_messages}" if logger
            nil
          end
        else
          logger.error "MailHandler: failed to create User: no FROM address found" if logger
          nil
        end
      end

      def from_object
        if Redmine::VERSION::MAJOR >= 2
          email['from'].decoded
          email['from'].addrs.first
        else
          email.from_addrs.first
        end
      end

      def from_address
        from_object && from_object.address
      end

      def from_name
        if from_object
          if Redmine::VERSION::MAJOR >= 2
            from_object.name
          else
            TMail::Unquoter.unquote_and_convert_to(from_object.name, 'utf-8')
          end
        end
      end
    end
  end
end
