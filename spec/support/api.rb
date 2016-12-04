def log_in(user)
  @user = user
  @auth = @user.create_new_auth_token
end

def api(method, path, params: {}, headers: {}, auth: nil, team: nil)
  headers.each {|k, v| request.headers[k] = v }
  (auth || @auth).each {|k, v| request.headers[k] = v }
  request.headers['API-Version']  = '1'
  request.headers['Accept'] = 'application/json'
  params[:team] = team || @user.name

  send(method, path, params: params)
end

def device_api(method, path, body: "", params: {}, headers: {})
  headers.each {|k, v| request.headers[k] = v }
  @request.env['RAW_POST_DATA'] = body

  send(method, path, params: params)
  @request.env.delete('RAW_POST_DATA')
end
