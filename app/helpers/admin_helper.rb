module AdminHelper
  def nav_link cont, act=nil
    c = Rails.application.routes.recognize_path(request.url)
    class_name = nil
    if act
      if c[:action] == act && c[:controller] == cont
        class_name = 'active'
      end
    else
      if c[:controller] == cont
        class_name = 'active'
      end
    end
    content_tag :li, class: class_name do
      yield
    end
  end

  def sortable_header(text, field='')
    sort_direction = params.fetch(:sort_direction, "asc")
    if sort_direction == "asc"
      sort_direction = "desc"
    else
      sort_direction = "asc"
    end
    content_tag :th do
      link_to text, params.merge({sort_field: field, sort_direction: sort_direction})
    end
  end

  def check_search_term email, search_term
    if search_term
      email.sub(search_term, "<strong>#{search_term}</strong>").html_safe
    else
      email
    end
  end
end
