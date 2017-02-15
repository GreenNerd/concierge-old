module ApplicationHelper
  def display_page_title(page_title)
    if page_title.present?
      "#{page_title}-在线排号系统"
    else
      '在线排号系统'
    end
  end

  def tabbar_item_class(name)
    controller_name.to_sym == name ? 'weui-tabbar__item weui-bar__item_on'.freeze : 'weui-tabbar__item'.freeze
  end
end
