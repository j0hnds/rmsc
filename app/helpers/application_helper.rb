module ApplicationHelper

  def form_label_field(f, field_name)
    "#{f.label field_name, mark_required(f.object, field_name)}#{f.text_field field_name, :class => 'text'}".html_safe
  end

  def mark_required(target, field_name)
    options = {}
    options[:class] = 'required' if target.class.validators_on(field_name).map(&:class).include? ActiveModel::Validations::PresenceValidator
    options
  end
end
