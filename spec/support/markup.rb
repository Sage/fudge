def link_to(url, text = nil)
  /<a.*href=.#{url}.*#{text}<\/a>/
end

def form_to(action)
  /<form.*action=.#{action}.*>/
end

def input_for(field)
  /<input.*name=.#{field}.*>/
end
