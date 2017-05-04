require 'redmine'
require 'user'
require 'redmine_anonymous_authors'
require 'redmine_anonymous_authors/hooks'

to_prepare = Proc.new do
  unless IssuesController.include?(RedmineAnonymousAuthors::IssuesControllerPatch)
    IssuesController.send :include, RedmineAnonymousAuthors::IssuesControllerPatch
  end
  unless ApplicationHelper.include?(RedmineAnonymousAuthors::ApplicationHelperPatch)
    ApplicationHelper.send :include, RedmineAnonymousAuthors::ApplicationHelperPatch
  end
  unless Issue.include?(RedmineAnonymousAuthors::IssuePatch)
    Issue.send :include, RedmineAnonymousAuthors::IssuePatch
  end
  unless Journal.include?(RedmineAnonymousAuthors::JournalPatch)
    Journal.send :include, RedmineAnonymousAuthors::JournalPatch
  end
  unless AnonymousUser.include?(RedmineAnonymousAuthors::AnonymousUserPatch)
    AnonymousUser.send :include, RedmineAnonymousAuthors::AnonymousUserPatch
  end
  unless Query.include?(RedmineAnonymousAuthors::QueryPatch)
    Query.send :include, RedmineAnonymousAuthors::QueryPatch
  end
  unless QueriesHelper.include?(RedmineAnonymousAuthors::QueriesHelperPatch)
    QueriesHelper.send :include, RedmineAnonymousAuthors::QueriesHelperPatch
  end
  unless ActionView::Base.include?(RedmineAnonymousAuthors::Helper)
    ActionView::Base.send :include, RedmineAnonymousAuthors::Helper
  end
  unless Mailer.include?(RedmineAnonymousAuthors::MailerPatch)
    Mailer.send :include, RedmineAnonymousAuthors::MailerPatch
  end
  unless MailHandler.include?(RedmineAnonymousAuthors::MailHandlerPatch)
    MailHandler.send :include, RedmineAnonymousAuthors::MailHandlerPatch
  end
end

if Redmine::VERSION::MAJOR >= 2
  Rails.configuration.to_prepare(&to_prepare)
else
  require 'dispatcher'
  Dispatcher.to_prepare(:redmine_anonymous_authors, &to_prepare)
end

Redmine::Plugin.register :redmine_anonymous_authors do
  name 'Redmine Anonymous Authors plug-in'
  author 'Anton Argirov'
  author_url 'http://redmine.academ.org'
  description "Allows to specify the author's name and the email for anonymously created issues."
  url "http://redmine.academ.org"
  version '0.0.4'

  settings :default => {
    :no_self_notified => '0',
    :hide_anonymous_email => '1',
    :anonymous_format => 'name'
  }, :partial => 'settings/anonymous_authors'
end

