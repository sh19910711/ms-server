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
    this.apps = [
    {
      title: "led-blink",
      link: "/apps",
      menu: [{
        title: "delete",
        link:  "/somewhere"
      }]
    },
    {
      title: "led-blink",
      menu: [{
        title: "delete",
        link:  "/somewhere"
      }]
    },
    {
      title: "led-blink",
      menu: [{
        title: "delete",
        link:  "/somewhere"
      }]
    }
    ];

    ProgressBar.done();
  }
}
