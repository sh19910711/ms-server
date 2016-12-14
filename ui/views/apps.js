import api from "api"
import NavBar from "components/navbar"
import List from "components/list"

require("./apps.scss");

export default {
  name: "apps",
  template: require("./apps.html"),
  components: {
    "nav-bar": NavBar,
    "simple-list": List
  },
  data() {
    return {
      breadcrumbs: [
        { title: "apps", url: this.$router.currentRoute.path }
      ],
      apps: [],
    }
  },
  created() {
    api.get_apps().then(r => {
      this.apps = r.json.apps.map(app => {
        return {
          title: app.name,
          onclick: () => {
            this.$router.push({ name: "app", params: { app_name: app.name }});
          }
        };
      });
    });
  }
}
