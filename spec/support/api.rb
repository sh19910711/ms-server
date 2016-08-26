def api(method, path, data = {})
  send method.downcase, path, params: data
end
