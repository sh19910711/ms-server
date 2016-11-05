require('./styles/main.scss');

import API from 'lib/api';
import Vue from 'vue';
import VueRouter from 'vue-router';

function createRouter() {
  function route(path, name) {
    return { name: name, path: path, component: require(`./pages/${name}.vue`) };
  }
  const routes = [
    route('/', 'index'),
    route('/signin', 'signin'),
    route('/signup', 'signup'),
    route('/signout', 'signout')
  ];
  return new VueRouter({ routes, mode: 'history' });
}

Vue.use(VueRouter);
window.api = new API(localStorage.getItem('cs-token'));
window.onload = _ => {
  const router = createRouter();
  router.beforeEach((nextPage, _, done) => {
    document.body.dataset.pageName = nextPage.name;
    done();
  });
  new Vue({ router }).$mount('#app');
};
