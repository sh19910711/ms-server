import App from './app';
import Login from './views/login';
import Dashboard from './views/dashboard';

const Vue = require("vue");
const VueRouter = require("vue-router");
Vue.use(VueRouter);

const router = new VueRouter({
  mode: "history",
  routes: [
    { path: "/",      component: Vue.extend(Dashboard) },
    { path: "/login", component: Vue.extend(Login) },
  ]
});

new Vue(Vue.util.extend({ router }, App)).$mount("#app");
