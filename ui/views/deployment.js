import NavBar from "components/navbar"
import BuildResult from "components/build_result"
import api from "api"


require("./deployment.scss");

export default {
  name: "deployment",
  template: require("./deployment.html"),
  components: {
    "nav-bar": NavBar,
    "build-result": BuildResult
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      app_name: this.$router.currentRoute.params.app_name,
      deployment_id: this.$router.currentRoute.params.deployment_id
    }
  },
  computed: {
    breadcrumbs: function() {
      return [
        { title: "apps", route: { name: "apps" }},
        { title: this.app_name, route: { name: "app",  params: { "app_name":  this.app_name }}},
        { title: "deployment", route: { name: "deployment", params: {}}}
      ];
    }
  },
  created() {
  }
}
