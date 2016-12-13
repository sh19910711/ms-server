import App from './app';
import Login from './views/login';
import Home from './views/home';

const Vue = require("vue");
const VueRouter = require("vue-router");
Vue.use(VueRouter);

const router = new VueRouter({
  mode: "history",
  routes: [
    { path: "/",      component: Vue.extend(Home) },
    { path: "/login", component: Vue.extend(Login) },
  ]
});

new Vue(Vue.util.extend({ router }, App)).$mount("#app");
