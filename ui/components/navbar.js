import api from "api";

const md5 = require("md5");

require("./navbar.scss");


export default {
  name: "nav-bar",
  template: require("./navbar.html"),
  props: ["breadcrumbs"],
  computed: {
    gravatar_url: function() {
      return "https://www.gravatar.com/avatar/" + md5(api.user.email) + "?s=40&d=mm";
    }
  }
}
