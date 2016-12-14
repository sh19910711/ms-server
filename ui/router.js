import Vue from "vue";
import VueRouter from "vue-router";
import Login from "./views/login";
import Home from "./views/home";


export default new VueRouter({
  mode: "history",
  routes: [
    { path: "/",      component: Vue.extend(Home) },
    { path: "/login", component: Vue.extend(Login) },
  ]
});
