@user = nil
@token = nil

def create_and_sign_in(username)
  unless @user
    @user = create(:chandler)
    @user.confirmed_at = Date.today
    @user.save!
  end

  unless @auth
    params = {
      username:    @user.name,
      password: @user.password
    }

    post '/api/auth/sign_in', params: params
    @token = response.headers['Token']
  end
end

def api(method, path, data = {})

  send(method.downcase, "/api/#{@user.name}/#{path}", params: data,
       headers: { 'Authorization' => "token #{@token}" })

  if response.header['Content-Type'] and \
    response.header['Content-Type'].include?('json')
    return JSON.parse(response.body)
  end
end
