module ApplicationHelper
  def full_title page_title
    base_title = t "base_title"
    if page_title.blank?
      base_title
    else
      [page_title, base_title].join(" || ")
    end
  end
end

def display_error object, method, name
  return unless object&.errors.present? && object.errors.key?(method)

  error = "#{name} #{object.errors.messages[method][0]}"
  content_tag :div, error, class: "error-feedback"
end

def toastr_flash type
  case type
  when "danger"
    "toastr.error"
  when "success"
    "toastr.success"
  else
    "toastr.info"
  end
end
