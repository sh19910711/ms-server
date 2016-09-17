def api(method, path, data = {})
  send(method.downcase, path, params: data)

  if response.header['Content-Type'].include?('json')
    return JSON.parse(response.body)
  end
end
