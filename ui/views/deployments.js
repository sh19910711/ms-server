import NavBar from "components/navbar"
import Card from "components/card"
import api from "api"


require("./deployments.scss");

export default {
  name: "deployments",
  template: require("./deployments.html"),
  components: {
    "navbar": NavBar,
    "card": Card
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      app_name: this.$router.currentRoute.params.app_name,
      deployments: []
    }
  },
  computed: {
    breadcrumbs:  function() {
      return [
        { title: "apps", route: { name: "apps" }},
        { title: this.app_name, route: { name: "app",  params: { "app_name":  this.app_name }}},
        { title: "deployments", route: { name: "deployments", params: {}}}
      ]
    }
  },
  created() {
    api.get_deployments(this.team, this.app_name).then(r => {
      this.deployments = r.json.deployments;
    });
  }
}
