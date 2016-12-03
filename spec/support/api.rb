def log_in(user)
  @user = user
  @auth = @user.create_new_auth_token
end

def api(method, path, params: {}, headers: {})
  @auth.each {|k, v| request.headers[k] = v }
  request.headers['API-Version']  = '1'
  request.headers['Accept'] = 'application/json'
  params[:team] = @user.name

  send(method, path, params: params)
end
