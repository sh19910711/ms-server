import Vue from "vue";
import ProgressBar from "progressbar"
import VueRouter from "vue-router"
import router from "./router";

require("./main.scss");

let App = {
  name: "app",
  template: require("./main.html")
};

Vue.use(VueRouter);

router.beforeEach((to, from, next) => {
  ProgressBar.start();
  document.title = to.meta.title;
  next();
})

new Vue(Vue.util.extend({ router }, App)).$mount("#app");
