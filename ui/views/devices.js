import api from "api"
import NavBar from "components/navbar"
import ProgressBar from "progressbar"
import Card from "components/card"

require("./devices.scss");

export default {
  name: "devices",
  template: require("./devices.html"),
  components: {
    "navbar": NavBar,
    "card": Card
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      breadcrumbs: [
        { title: "devices", route: {name: "devices"}}
      ],
      devices: []
    }
  },
  created() {
    api.get_devices(this.team).then(r => {
      this.devices = r.json.devices;
      ProgressBar.done();
    });
  }
}
