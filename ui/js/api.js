import "whatwg-fetch";
import {set_statusbar} from "components/statusbar"

export default new class {
  constructor() {
    this.user        = JSON.parse(localStorage.getItem("user"));
    this.team        = JSON.parse(localStorage.getItem("team"));
    this.credentials = JSON.parse(localStorage.getItem("credentials"));
  }

  invoke(method, path, params) {
    let req_headers = Object.assign({
                        "Content-Type": "application/json"
                      }, this.credentials);

    return new Promise((resolve, reject) => {
      let status;
      let headers;
      fetch(`/api${path}`, {
        method: method,
        headers: req_headers,
        body: JSON.stringify(params)
      }).then((response) => {
        status = response.status;
        headers = response.headers;
        return response;
      }).then((response) => {
        return response.json();
      }).then((json) => {
        if (200 <= status && status <= 299)
          resolve({status, headers, json });
        else
          reject({status, headers, json });
      });
    });
  }

  logout() {
    localStorage.removeItem("user");
    localStorage.removeItem("team");
    localStorage.removeItem("credentials");
  }

  login(username, password) {
    return this.invoke("POST", "/auth/sign_in", {
      name: username,
      password: password
    }).then(r => {
      this.user = {
        name:  r.json["data"]["name"],
        email: r.json["data"]["email"]
      };

      this.team = this.user.name;
      this.credentials = {
        uid:            r.headers.get("uid"),
        client:         r.headers.get("client"),
        "access-token": r.headers.get("access-token")
      };

      localStorage.setItem("user", JSON.stringify(this.user));
      localStorage.setItem("team", JSON.stringify(this.team));
      localStorage.setItem("credentials", JSON.stringify(this.credentials));
    });
  }

  get_apps(team) {
    return this.invoke("GET", `/${team}/apps`);
  }

  get_devices(team) {
    return this.invoke("GET", `/${team}/devices`);
  }

  get_device_log(team, device_name) {
    return this.invoke("GET", `/${team}/devices/${device_name}/log`);
  }

  get_deployments(team, app_name) {
    return this.invoke("GET", `/${team}/apps/${app_name}/deployments`);
  }

  get_deployment(team, app_name, version) {
    return this.invoke("GET", `/${team}/apps/${app_name}/deployments/${version}`);
  }

  create_app(team, app_name) {
    return this.invoke("POST", `/${team}/apps`, { app_name: app_name });
  }

  add_device_to_app(team, app_name, device_name) {
    return this.invoke("POST", `/${team}/apps/${app_name}/devices`,
                       { device_name: device_name });
  }
}
