import api from "api";

require("./buildlog.scss");


function parse_build_log(build_log) {
  let lines = build_log.split("\n");
  let stages = [];
  let actions = [];
  let log = [];
  let stage_title = "";
  let action_title = "";
  let action_result;
  for (let l of lines) {
    if (l.startsWith(">>> stage_end")) {
      stages.push({
        title: stage_title,
        actions: actions
      });
    } else if (l.startsWith(">>> stage:")) {
      stage_title = l.replace(/^>>> stage: /, "");
      actions = [];
    } else if (l.startsWith(">>> action_end")) {
      action_result = l.replace(/^>>> action_end: /, "");
      actions.push({
        title: action_title,
        result: action_result,
        show: false,
        log: log
      });
    } else if (l.startsWith(">>> action:")) {
      action_title = l.replace(/^>>> action: /, "");
      log = [];
    } else {
      log.push(l);
    }
  }

  return stages;
}


export default {
  name: "buildlog",
  template: require("./buildlog.html"),
  props: ["build_log"],
  computed: {
    stages: function() {
      return parse_build_log(this.build_log);
    }
  },
  methods: {
    show_log: function(stage, action) {
      this.stages[stage].actions[action].show = !this.stages[stage].actions[action].show;
      this.$forceUpdate();
    }
  }
}
