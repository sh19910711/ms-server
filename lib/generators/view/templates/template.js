import NavBar from "components/navbar"

require("./<%= file_name %>.scss");

export default {
  name: "<%= file_name %>",
  template: require("./<%= file_name %>.html"),
  components: {
    "nav-bar": NavBar
  },
  data() {
    return {
    }
  },
  created() {
  }
}
