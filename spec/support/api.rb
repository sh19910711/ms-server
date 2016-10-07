@user = nil
@auth = nil

def create_and_sign_in(username)
  unless @user
    @user = create(:chandler)
    @user.confirmed_at = Date.today
    @user.save!
  end

  unless @auth
    params = {
      email:    @user.email,
      password: @user.password
    }

    post '/api/auth/sign_in', params: params
    @auth = response.headers
  end
end

def api(method, path, data = {})
  headers = {
    'uid' => @auth['uid'],
    'access-token' => @auth['access-token'],
    'client' => @auth['client']
  }

  send(method.downcase, "/api/#{@user.name}/#{path}", params: data,
       headers: headers)

  if response.header['Content-Type'] and \
    response.header['Content-Type'].include?('json')
    return JSON.parse(response.body)
  end
end
