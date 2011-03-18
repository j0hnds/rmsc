module ApplicationHelper

  def form_label_field(f, field_name, clazz=nil)
    "#{f.label field_name, mark_required(f.object, field_name)}#{f.text_field field_name, :class => ((clazz) ? clazz : 'text')}".html_safe
  end

  def mark_required(target, field_name)
#    options = {}
#    options[:class] = 'required' if target.class.validators_on(field_name).map(&:class).include? ActiveModel::Validations::PresenceValidator
#    options
    label = "#{field_name.to_s.humanize}:"
    label = "#{field_name.to_s.humanize}: <em><img src=\"images/required-star.png\" alt=\"required\" /></em>" if target.class.validators_on(field_name).map(&:class).include? ActiveModel::Validations::PresenceValidator
    label.html_safe
  end

  def row_odd_even(row_index)
    ((row_index % 2) == 0) ? 'even' : 'odd'
  end

  def state_options
    [["Alabama", "AL"], ["Alaska", "AK"], ["American Samoa", "AS"], ["Arizona", "AZ"], ["Arkansas", "AR"], ["California", "CA"], ["Colorado", "CO"], ["Connecticut", "CT"], ["Delaware", "DE"], ["District Of Columbia", "DC"], ["Federated States Of Micronesia", "FM"], ["Florida", "FL"], ["Georgia", "GA"], ["Guam", "GU"], ["Hawaii", "HI"], ["Idaho", "ID"], ["Illinois", "IL"], ["Indiana", "IN"], ["Iowa", "IA"], ["Kansas", "KS"], ["Kentucky", "KY"], ["Louisiana", "LA"], ["Maine", "ME"], ["Marshall Islands", "MH"], ["Maryland", "MD"], ["Massachusetts", "MA"], ["Michigan", "MI"], ["Minnesota", "MN"], ["Mississippi", "MS"], ["Missouri", "MO"], ["Montana", "MT"], ["Nebraska", "NE"], ["Nevada", "NV"], ["New Hampshire", "NH"], ["New Jersey", "NJ"], ["New Mexico", "NM"], ["New York", "NY"], ["North Carolina", "NC"], ["North Dakota", "ND"], ["Northern Mariana Islands", "MP"], ["Ohio", "OH"], ["Oklahoma", "OK"], ["Oregon", "OR"], ["Palau", "PW"], ["Pennsylvania", "PA"], ["Puerto Rico", "PR"], ["Rhode Island", "RI"], ["South Carolina", "SC"], ["South Dakota", "SD"], ["Tennessee", "TN"], ["Texas", "TX"], ["Utah", "UT"], ["Vermont", "VT"], ["Virgin Islands", "VI"], ["Virginia", "VA"], ["Washington", "WA"], ["West Virginia", "WV"], ["Wisconsin", "WI"], ["Wyoming", "WY"]]
  end

  def span_menu(item)
    "<span>#{item}</span>".html_safe
  end

end
