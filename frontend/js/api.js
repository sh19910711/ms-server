import 'whatwg-fetch';

function handleContent(res) {
  const contentType = res.headers.get('Content-Type');
  if (contentType && contentType.indexOf('application/json') !== -1) {
    return res.json();
  } else {
    return res;
  }
}

class API {
  constructor() {
    this.user = JSON.parse(localStorage.getItem('user'));
    this.headers = JSON.parse(localStorage.getItem('headers'));
  }

  signup(params) {
    return this.send('post', '/api/auth', params);
  }

  signin(params) {
    return this.send('post', '/api/auth/sign_in', params).then(res => {
      this.headers = this.headers || {};
      ['uid', 'client', 'access-token'].forEach(k => (this.headers[k] = res.response.headers.get(k)));
      localStorage.setItem('user', JSON.stringify(this.user = params.name));
      localStorage.setItem('headers', JSON.stringify(this.headers));
    });
  }

  signout() {
    const clear = () => {
      localStorage.removeItem('user');
      localStorage.removeItem('headers');
      this.user = null;
      this.headers = null;
    };
    return this.send('delete', '/api/auth/sign_out').then(clear).catch(clear);
  }

  apps(team) {
    return this.send('get', `/api/${team}/apps`);
  }

  devices(team) {
    return this.send('get', `/api/${team}/devices`);
  }

  appBuilds(team, appName) {
    return this.send('get', `/api/${team}/apps/${appName}/builds`);
  }

  appDeployments(team, appName) {
    return this.send('get', `/api/${team}/apps/${appName}/deployments`);
  }

  deviceEnvvars({team, deviceName}) {
    return this.send('get', `/api/${team}/devices/${deviceName}/envvars`);
  }

  deviceSetEnvvar({team, device_name, name, value}) {
    return this.send('put', `/api/${team}/devices/${device_name}/envvars/${name}`, { value });
  }

  deviceLog({team, deviceName}) {
    return this.send('get', `/api/${team}/devices/${deviceName}/log`);
  }

  deviceApp({team, app_name, device_name}) {
    return this.send('post', `/api/${team}/apps/${app_name}/devices`, {'device_name': device_name});
  }

  send(method, url, params) {
    return new Promise((resolve, reject) => {
      const headers = {'Content-Type': 'application/json'};
      if (this.headers) Object.assign(headers, this.headers);
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

export default new API();
