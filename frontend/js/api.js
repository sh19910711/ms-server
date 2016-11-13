import 'whatwg-fetch';

const USER_KEY = 'username';
const API_TOKEN_KEY = 'api-token';

function handleContent(res) {
  const contentType = res.headers.get('Content-Type');
  if (contentType && contentType.indexOf('application/json') !== -1) {
    return res.json();
  } else {
    return res;
  }
}

class API {
  constructor(token, user) {
    this.token = token;
    this.user = user;
  }

  signup(params) {
    return this.send('post', '/api/auth', params).then(res => {
      localStorage.setItem(USER_KEY, JSON.stringify(this.user = res.response.headers.get('username')));
      localStorage.setItem(API_TOKEN_KEY, JSON.stringify(this.token = res.response.headers.get('token')));
    });
  }

  signin(params) {
    return this.send('post', '/api/auth/sign_in', params).then(res => {
      localStorage.setItem(USER_KEY, JSON.stringify(this.user = res.response.headers.get('username')));
      localStorage.setItem(API_TOKEN_KEY, JSON.stringify(this.token = res.response.headers.get('token')));
    });
  }

  signout() {
    const clear = () => {
      localStorage.removeItem(USER_KEY);
      localStorage.removeItem(API_TOKEN_KEY);
      this.user = null;
      this.token = null;
    };
    return this.send('delete', '/api/auth/sign_out').then(clear).catch(clear);
  }

  apps(team) {
    return this.send('get', `/api/${team}/apps`);
  }

  devices(team) {
    return this.send('get', `/api/${team}/devices`);
  }

  send(method, url, params) {
    return new Promise((resolve, reject) => {
      const headers = {'Content-Type': 'application/json'};
      if (this.token) headers['Authorization'] = `token ${this.token}`;
      const request = {method, headers};
      if (params) request['body'] = JSON.stringify(params);
      let response;
      fetch(url, request)
        .then(res => (response = res))
        .then(handleContent)
        .then(content => {
          if (response.ok) {
            resolve({content, response});
          } else {
            reject({content, response});
          }
        });
    });
  }
}

const user = JSON.parse(localStorage.getItem(USER_KEY));
const token = JSON.parse(localStorage.getItem(API_TOKEN_KEY));
export default new API(token, user);
