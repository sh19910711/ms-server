require('./main.scss');

import Vue from 'vue';
import VueRouter from 'vue-router';

function createRouter() {
  function route(path, name) {
    return { path, name, component: Vue.extend(require(`./${name}`).default) };
  }
  const routes = [
    route('/', 'index'),
    route('/signin', 'signin'),
    route('/signup', 'signup'),
    route('/signout', 'signout'),
    route('/apps', 'apps'),
    route('/apps/:name', 'app_overview'),
    route('/apps/:name/deployments', 'app_deployments'),
    route('/apps/:name/builds', 'app_builds'),
    route('/apps/:name/builds/:build_id', 'app_build_detail'),
    route('/apps/:name/devices', 'app_devices'),
    route('/devices', 'devices'),
    route('/devices/:name', 'device_detail')
  ];
  return new VueRouter({ routes, mode: 'history' });
}

Vue.use(VueRouter);

window.onload = () => {
  const router = createRouter();
  router.beforeEach((nextPage, _, done) => {
    document.body.dataset.pageName = nextPage.name;
    done();
  });
  new Vue({ router }).$mount('#app');
};
