import NavBar from "components/navbar"
import api from "api"


require("./<%= file_name %>.scss");

export default {
  name: "<%= file_name %>",
  template: require("./<%= file_name %>.html"),
  components: {
    "nav-bar": NavBar
  },
  data() {
    return {
      team: this.$router.currentRoute.params.team || api.user.name,
      breadcrumbs: [
        { title: "<%= file_name %>", route: { name: "<%= file_name %>", params: {}}}
      ]
    }
  },
  created() {
  }
}
