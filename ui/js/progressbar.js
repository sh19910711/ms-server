import NProgress from "nprogress";

export default {
  start() {
    NProgress.configure({
      showSpinner: false
    });

    NProgress.start(0.4);
  },
  done() {
    NProgress.done();
  }
}
