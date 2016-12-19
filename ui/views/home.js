import ProgressBar from "progressbar"
import NavBar from "components/navbar"


export default {
  name: "home",
  template: require("./home.html"),
  components: {
    "navbar": NavBar
  },
  data() {
    return {
      "apps": []
    }
  },
  created() {
    // TODO
    this.$router.push({name: "apps"});
  }
}
