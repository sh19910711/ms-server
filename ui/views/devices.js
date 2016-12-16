import api from "api"
import NavBar from "components/navbar"
import List from "components/list"
import Card from "components/card"

require("./devices.scss");

export default {
  name: "devices",
  template: require("./devices.html"),
  components: {
    "nav-bar": NavBar,
    "card": Card,
    "list": List
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      breadcrumbs: [
        { title: "devices", route: {name: "devices"}}
      ],
      devices: [],
    }
  },
  created() {
    api.get_devices(this.team).then(r => {
      this.devices = r.json.devices;
    });
  }
}
