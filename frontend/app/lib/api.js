import 'whatwg-fetch';

const TOKEN_KEY = 'api-token';

function handleContent(res) {
  const contentType = res.headers.get('Content-Type');
  if (contentType && contentType.indexOf('application/json') != -1) {
    return res.json();
  } else {
    return res;
  }
}

class API {
  constructor(token) {
    this.token = token;
  }

  signup(params) {
    return this.send('post', '/api/auth', params).then(res => {
      localStorage.setItem(TOKEN_KEY, JSON.stringify(this.token = res.response.headers.get('token')));
    });
  }

  signin(params) {
    return this.send('post', '/api/auth/sign_in', params).then(res => {
      localStorage.setItem(TOKEN_KEY, JSON.stringify(this.token = res.response.headers.get('token')));
    });
  }

  signout() {
    return this.send('delete', '/api/auth/sign_out').then(res => {
      localStorage.removeItem(TOKEN_KEY);
      this.token = null;
    });
  }

  apps(team) {
    return this.send('get', `/api/${team}/apps`)
  }

  send(method, url, params) {
    return new Promise((resolve, reject) => {
      const body = JSON.stringify(params || {});
      const headers = {'Content-Type': 'application/json'};
      if (this.token) headers['Authorization'] = `token ${this.token}`;
      let response;
      fetch(url, {method, headers, body})
        .then(res => response = res)
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
};

export default new API(JSON.parse(localStorage.getItem(TOKEN_KEY)));
