import NavBar from "components/navbar"
import BuildLog from "components/buildlog"
import api from "api"


require("./deployment.scss");

export default {
  name: "deployment",
  template: require("./deployment.html"),
  components: {
    "navbar": NavBar,
    "build-result": BuildLog
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      app_name: this.$router.currentRoute.params.app_name,
      major_version: this.$router.currentRoute.params.major_version,
      status: "",
      build_log: "",
      updated_at: null,
      created_at: null
    }
  },
  computed: {
    breadcrumbs: function() {
      return [
        { title: "apps", route: { name: "apps" }},
        { title: this.app_name, route: { name: "app",  params: { "app_name":  this.app_name }}},
        { title: "deployments", route: { name: "deployments",  params: { "app_name":  this.app_name }}},
        { title: `#${this.major_version}`, route: { name: "deployment", params: {}}}
      ];
    }
  },
  created() {
    api.get_deployment(this.team, this.app_name, this.major_version).then(r => {
      this.status     = r.json.build.status;
      this.build_log  = r.json.build.log;
      this.created_at = (new Date(r.json.created_at)).toLocaleString();
      this.updated_at = (new Date(r.json.updated_at)).toLocaleString();
    });
  }
}
