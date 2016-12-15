import api from "api"
import NavBar from "components/navbar"
import List from "components/list"
import Modal from "components/modal"


require("./apps.scss");

export default {
  name: "apps",
  template: require("./apps.html"),
  components: {
    "nav-bar": NavBar,
    "list": List,
    "modal": Modal
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      breadcrumbs: [
        { title: "apps", route: {name: "apps"}}
      ],
      apps: [],
      app_name: "",
      show_create_modal: false
    }
  },
  methods: {
    create_app: function() {
      api.create_app(this.team, this.app_name).then(() => {
        // TODO: statusbar
        this.$router.push({ name: "app", params: { app_name: this.app_name }});
      });
    },
  },
  created() {
    api.get_apps(this.team).then(r => {
      this.apps = r.json.apps.map(app => {
        return {
          title: app.name,
          clickable: true,
          onclick: () => {
            this.$router.push({ name: "app", params: { app_name: app.name }});
          },
        };
      });
    });
  }
}
