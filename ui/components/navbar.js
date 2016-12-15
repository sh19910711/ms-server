import api from "api";
import Dropdown from "components/dropdown";
import {get_statusbar, StatusBar} from "components/statusbar";

const md5 = require("md5");

require("./navbar.scss");


export default {
  name: "navbar",
  components: {
    "dropdown": Dropdown,
    "statusbar": StatusBar
  },
  template: require("./navbar.html"),
  props: ["breadcrumbs"],
  data() {
    return {
      show_menu: false,
      statusbar_status: "",
      statusbar_body: ""
    }
  },
  computed: {
    gravatar_url: function() {
      return "https://www.gravatar.com/avatar/" + md5(api.user.email) + "?s=40&d=mm";
    }
  },
  created() {
    let statusbar = get_statusbar();
    if (statusbar) {
      this.statusbar_status = statusbar.status;
      this.statusbar_body   = statusbar.body;
    }
  }
}
