def link_to(url, text = nil)
  /a.*href=.#{url}.*#{text}/
end
