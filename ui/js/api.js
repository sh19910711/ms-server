import "whatwg-fetch";

export default new class {
  constructor() {
    this.user        = JSON.parse(localStorage.getItem("user"));
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

  login(username, password) {
    return this.invoke("POST", "/auth/sign_in", {
      name: username,
      password: password
    }).then(r => {
      this.user = {
        name:  r.json["data"]["name"],
        email: r.json["data"]["email"]
      };

      this.credentials = {
        uid:            r.headers.get("uid"),
        client:         r.headers.get("client"),
        "access-token": r.headers.get("access-token")
      };

      localStorage.setItem("user", JSON.stringify(this.user));
      localStorage.setItem("credentials", JSON.stringify(this.credentials));
    });
  }
}
