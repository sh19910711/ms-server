import api from "api"
import ProgressBar from "progressbar"
import NavBar from "components/navbar"
import {set_statusbar} from "components/statusbar"
import Card from "components/card"
import Modal from "components/modal"


require("./apps.scss");

export default {
  name: "apps",
  template: require("./apps.html"),
  components: {
    "navbar": NavBar,
    "card": Card,
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
    }
  },
  created() {
    api.get_apps(this.team).then(r => {
      this.apps = r.json.apps;
      ProgressBar.done();
    });
  }
}
