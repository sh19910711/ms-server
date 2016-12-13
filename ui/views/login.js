import api from "api";

require("./login.scss");

export default {
  name: "login",
  template: require("./login.html"),
  data: () => {
    return {
      username: "",
      password: "",
      failed: false
    }
  },
  methods: {
    login() {
      api.login(this.username, this.password).then(() => {
        this.$router.push("/")
      }).catch((r) => {
        console.log(r);
        this.failed = true;
      });
    }
  }
}
