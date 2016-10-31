@user = nil
@token = nil

def create_and_sign_in(username)
  unless @user
    @user = create(username)
    @user.confirmed_at = Date.today
    @user.save!
  end

  unless @auth
    params = {
      username: @user.name,
      password: @user.password
    }

    post '/api/auth/sign_in', params: params
    @token = response.headers['Token']
  end
end

def api(method: '', path: '', data: {}, headers: {}, with_team_prefix: true)

  headers['API-Version']  = '1'
  headers['Authorization'] = "token #{@token}"

  if with_team_prefix
    path = "/api/#{@user.name}/#{path}"
  else
    path = "/api/#{path}"
  end

  send(method.downcase, path, params: data, headers: headers)

  if response.header['Content-Type'] and \
    response.header['Content-Type'].include?('json')
    return JSON.parse(response.body)
  else
    return response.body
  end
end
