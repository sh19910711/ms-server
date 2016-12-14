import Vue from "vue";
import VueRouter from "vue-router";
import LoginView from "./views/login";
import AppsView from "./views/apps";
import AppView from "./views/app";
import HomeView from "./views/home";


export default new VueRouter({
  mode: "history",
  routes: [
    { name: "home",  path: "/",               component: Vue.extend(HomeView)  },
    { name: "apps",  path: "/apps",           component: Vue.extend(AppsView)  },
    { name: "app",   path: "/apps/:app_name", component: Vue.extend(AppView)   },
    { name: "login", path: "/login",          component: Vue.extend(LoginView) },
  ]
});
