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
      team: this.$router.currentRoute.params.team || api.user.name,
      breadcrumbs: [
        { title: "apps", url: this.$router.currentRoute.path }
      ],
      apps: [],
    }
  },
  created() {
    api.get_apps(this.team).then(r => {
      this.apps = r.json.apps.map(app => {
        return {
          title: app.name,
          clickable: true,
          onclick: () => {
            this.$router.push({ name: "app", params: { app_name: app.name }});
          }
        };
      });
    });
  }
}
