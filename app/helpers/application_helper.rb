module ApplicationHelper

  def form_label_field(f, field_name)
    "#{f.label field_name}: #{f.text_field field_name}".html_safe
  end
end
