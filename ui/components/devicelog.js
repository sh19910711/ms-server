require("./devicelog.scss");

export default {
  name: "devicelog",
  template: require("./devicelog.html"),
  props: ["log"],
  computed: {
    lines() {
      let lines = [];
      for (let line of this.log) {
        let [date, index, ...words] = line.split(":");
        let [status, ...body] = words.join(" ").split("> ");
        let log = body.join(" ");

        lines.push({
          date: "",
          log: log
        });
      }
      return lines;
    }
  }
}
