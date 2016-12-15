import Vue from "vue";
import VueRouter from "vue-router";
import NProgress from "nprogress";
import App from "./app";
import router from "./router";


Vue.use(VueRouter);

router.beforeEach((to, from, next) => {
  document.title = to.meta.title;
  next();
})

router.beforeEach((to, from, next) => {
  NProgress.configure({
    spinner: false
  });
  NProgress.start(0.4);
  next();
})

router.afterEach((to, from) => {
  NProgress.done();
})

new Vue(Vue.util.extend({ router }, App)).$mount("#app");
