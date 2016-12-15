import NavBar from "components/navbar"
import Modal from "components/modal"
import api from "api"


require("./device.scss");

export default {
  name: "device",
  template: require("./device.html"),
  components: {
    "nav-bar": NavBar,
    "modal": Modal
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      device_name: this.$router.currentRoute.params.device_name,
      show_add_modal: false,
      apps: [],
      add_device_to: ""
    }
  },
  computed: {
    breadcrumbs: function() {
      return [
        { title: "devices", route: { name: "devices"}},
        { title: this.device_name,
          route: { name: "device", params: {device_name: this.device_name }}}
      ]
    },
    add_modal_submit_button: function() {
      return `add ${this.device_name} to ${this.add_device_to}`;
    }
  },
  methods: {
    add_to_app() {
      api.add_device_to_app(this.team, this.add_device_to, this.device_name).then(() => {
        // TODO: error handling / statusbar
        this.show_add_modal = false;
      });
    }
  },
  created() {
    document.title = this.device_name;
    api.get_apps(this.team).then(r => {
      this.apps = r.json.apps;
      // FIXME: what if there are no apps?
      this.add_device_to = this.apps[0].name;
    });
  }
}
