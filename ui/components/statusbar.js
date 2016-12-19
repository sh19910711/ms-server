import Cookies from "js-cookie";
require("./statusbar.scss");

export function get_statusbar() {
  let statusbar = Cookies.getJSON("statusbar");
  Cookies.remove("statusbar");
  return statusbar;
}

export function set_statusbar(status, body) {
  Cookies.set("statusbar", {
    status: status,
    body, body
  });
}

export const StatusBar = {
  name: "statusbar",
  template: require("./statusbar.html"),
  props: ["status", "body"],
  data() {
    return {
      show: false
    }
  },
  created() {
    if (this.status) {
      this.show = true;
    }
  }
}
