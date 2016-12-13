import App from './app';

const Vue = require("vue");
const VueRouter = require("vue-router");
Vue.use(VueRouter);

const router = new VueRouter({
  mode: "history",
  routes: [
  ]
});

new Vue(Vue.util.extend({ router }, App)).$mount("#app");
