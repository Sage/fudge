def link_to(url, text = nil)
  /<a.*href=.#{url}.*#{text}<\/a>/
end

def form_to(action, options = {})
  extra = ""
  if options[:method]
    extra = /.*method=.#{options[:method]}.+/
  end
  /<form.*action=.#{action}.*#{extra}>/
end

def input_for(field)
  /<input.*name=.#{field}.*>/
end
