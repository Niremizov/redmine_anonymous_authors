module RedmineAnonymousAuthors
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_edit_notes_bottom, :partial => 'anonymous_authors/issues_edit'
    render_on :view_issues_form_details_top, :partial => 'anonymous_authors/issues_form'
  end
end