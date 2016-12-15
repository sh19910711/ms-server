import api from "api";
import Dropdown from "components/dropdown";

const md5 = require("md5");

require("./navbar.scss");


export default {
  name: "nav-bar",
  components: {
    "dropdown": Dropdown
  },
  template: require("./navbar.html"),
  props: ["breadcrumbs"],
  data() {
    return {
      show_menu: false
    }
  },
  computed: {
    gravatar_url: function() {
      return "https://www.gravatar.com/avatar/" + md5(api.user.email) + "?s=40&d=mm";
    }
  }
}
