module ApplicationHelper
  def flash_classname(message_type)
    case message_type
    when 'notice'
      'alert alert-info'
    when 'success'
      'alert alert-success'
    when 'error'
      'alert alert-error'
    when 'alert'
      'alert alert-warning'
    else
      'alert alert-info'
    end
  end
end
