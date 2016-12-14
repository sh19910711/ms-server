import Vue from "vue";
import VueRouter from "vue-router";
import LoginView from "./views/login";
import AppsView from "./views/apps";
import AppView from "./views/app";
import HomeView from "./views/home";
import DevicesView from "./views/devices";
import DeploymentView from "./views/deployment";
import DeploymentsView from "./views/deployments";


export default new VueRouter({
  mode: "history",
  routes: [
    { name: "home",    path: "/",               component: Vue.extend(HomeView)  },
    { name: "apps",    path: "/apps",           component: Vue.extend(AppsView)  },
    { name: "app",     path: "/apps/:app_name", component: Vue.extend(AppView)   },
    { name: "deployments", path: "/apps/:app_name/deployments", component: Vue.extend(DeploymentsView) },
    { name: "deployment", path: "/apps/:app_name/deployments/:major_version", component: Vue.extend(DeploymentView) },
    { name: "devices", path: "/devices",        component: Vue.extend(DevicesView)  },
    { name: "team_devices", path: "/:team/devices",  component: Vue.extend(DevicesView)  },
    { name: "login",   path: "/login",          component: Vue.extend(LoginView) },
  ]
});
