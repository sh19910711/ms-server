import NavBar from "components/navbar"

require("./app.scss");

export default {
  name: "app",
  template: require("./app.html"),
  components: {
    "nav-bar": NavBar
  },
  data() {
    return {
      app_name: this.$router.currentRoute.params.app_name
    }
  },
  created() {
  }
}
