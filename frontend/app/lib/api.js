import request from 'superagent';

export default class API {
  constructor(token) {
    this.token = token;
  }

  signup(params) {
    return this.send('post', '/api/auth', params);
  }

  signin(params) {
    return this.send('post', '/api/auth/sign_in', params);
  }

  signout() {
    return this.send('delete', `/api/auth/sign_out`);
  }

  apps(team) {
    return this.send('get', `/api/${team}/apps`)
  }

  send(method, url, params) {
    return new Promise((resolve, reject) => {
      const req = request[method](url)
      if (this.token) req.set('authorization', `token ${this.token}`);
      if (params) req.send(params);
      req.end((err, res) => (err ? reject : resolve)(res));
    });
  }
};
