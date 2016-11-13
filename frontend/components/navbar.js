import api from 'js/api';

require('./navbar.scss');

export default {
  template: require('./navbar.html'),
  components: { breadcrumbs: require('./navbar/breadcrumbs').default },
  name: 'navbar',
  data() {
    return {
      team: api.user,
      token: api.token
    };
  },
  methods: {
    needLogin() {
      return !this.token;
    }
  }
};
