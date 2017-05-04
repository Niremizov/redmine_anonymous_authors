module RedmineAnonymousAuthors
  module Helper
    def link_to_mail(mail, name = nil, html_options = {})
      link_to h(name || mail), "mailto:#{mail}", html_options
    end
  end
end
