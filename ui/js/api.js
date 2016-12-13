import "whatwg-fetch";

class API {
  constuctor() {
    this.username    = localStorage.getItem("username");
    this.credentials = JSON.parse(localStorage.getItem("credentials"));
  }

  invoke(method, path, params, parse_json=false) {
    let headers = Object.assign({
                    "Content-Type": "application/json"
                  }, this.credentials);

    return new Promise((resolve, reject) => {
      fetch(`/api${path}`, {
        method: method,
        headers: headers,
        body: JSON.stringify(params)
      }).then((response) => {
        if (200 <= response.status && response.status <= 299)
          resolve(response);
        else
          reject(response);
      });
    });
  }

  login(username, password) {
    return this.invoke("POST", "/auth/sign_in", {
      name: username,
      password: password
    }).then(r => {
      this.username = username;
      this.credentials = {
        uid:            r.headers.get("uid"),
        client:         r.headers.get("client"),
        "access-token": r.headers.get("access-token")
      };

      localStorage.setItem("username", this.username);
      localStorage.setItem("credentials", JSON.stringify(this.credentials));
    });
  }
}

export default new API();
