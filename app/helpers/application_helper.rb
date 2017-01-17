module ApplicationHelper
  def display_page_title(page_title)
    if page_title.present?
      "#{page_title}-在线排号系统"
    else
      '在线排号系统'
    end
  end
end
