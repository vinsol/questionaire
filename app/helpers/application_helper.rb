module ApplicationHelper
  def get_error(obj, elem)
    obj.errors[elem].join(', ')
  end
end
