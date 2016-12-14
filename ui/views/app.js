import NavBar from "components/navbar"
import api from "api"


require("./app.scss");

export default {
  name: "app",
  template: require("./app.html"),
  components: {
    "nav-bar": NavBar
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      app_name: this.$router.currentRoute.params.app_name
    }
  },
  created() {
  }
}
