import Vue from "vue";
import VueRouter from "vue-router";
import LoginView from "./views/login";
import AppsView from "./views/apps";
import AppView from "./views/app";
import HomeView from "./views/home";
import DevicesView from "./views/devices";
import DeviceView from "./views/device";
import DeploymentView from "./views/deployment";
import DeploymentsView from "./views/deployments";


export default new VueRouter({
  mode: (location.host.indexOf("herokuapp.com") == -1) ? "history" : "hash",
  routes: [
    {
      name: "home",
      path: "/",
      component: Vue.extend(HomeView),
      meta: {
        title: "Home"
      }
    },
    {
      name: "apps",
      path: "/apps",
      component: Vue.extend(AppsView),
      meta: {
        title: "Apps"
      }
    },
    {
      name: "app",
      path: "/apps/:app_name",
      component: Vue.extend(AppView),
      meta: {
        title: "App"
      }
    },
    {
      name: "deployments",
      path: "/apps/:app_name/deployments",
      component: Vue.extend(DeploymentsView),
      meta: {
        title: "Deployment"
      }
    },
    {
      name: "deployment",
      path: "/apps/:app_name/deployments/:version",
      component: Vue.extend(DeploymentView),
      meta: {
        title: "Deployment"
      }
    },
    {
      name: "devices",
      path: "/devices",
      component: Vue.extend(DevicesView),
      meta: {
        title: "Devices"
      }
    },
    {
      name: "device",
      path: "/devices/:device_name",
      component: Vue.extend(DeviceView),
      meta: {
        title: "Device"
      }
    },
    {
      name: "team_devices",
      path: "/:team/devices",
      component: Vue.extend(DevicesView),
      meta: {
        title: "Devices"
      }
    },
    {
      name: "login",
      path: "/login",
      component: Vue.extend(LoginView),
      meta: {
        title: "Login"
      }
    },
  ]
});
