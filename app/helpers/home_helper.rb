module HomeHelper
  def link_with_count(type, post)
    targets = post.url_targets(type)
    return if targets.length == 0 
    if targets.length <= 1
      return link_to post.url_count(type), targets.first, :class => type
    else
      return link_to post.url_count(type), targets.first, :class => type
    end
  end
end
