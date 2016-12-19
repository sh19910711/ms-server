import Vue from "vue";
import api from "api";
import {set_statusbar, get_statusbar, StatusBar} from "components/statusbar";
import ProgressBar from "progressbar"
import VueRouter from "vue-router"
import router from "./router";

require("./main.scss");

let App = {
  name: "app",
  template: require("./main.html"),
  components: {
    "statusbar": StatusBar
  },
  data() {
    return {
      statusbar_status: "",
      statusbar_body: ""
    }
  },
  created() {
    // FIXME: do this in beforeEach()
    if (!api.credentials && this.$router.currentRoute.name != "login") {
      // Authentication required.
      if (!["home", "login"].includes(this.$router.currentRoute.name))
        set_statusbar("failure", "Login first.");

      api.logout();
      this.$router.push({name: "login"});
    }

    let statusbar = get_statusbar();
    if (statusbar) {
      this.statusbar_status = statusbar.status;
      this.statusbar_body   = statusbar.body;
    }
  }
};

Vue.use(VueRouter);

router.beforeEach((to, from, next) => {
  ProgressBar.start();
  document.title = to.meta.title;
  next();
})

new Vue(Vue.util.extend({ router }, App)).$mount("#app");
