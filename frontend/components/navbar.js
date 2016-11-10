import api from 'js/api';

require('./navbar.scss');

export default {
  template: require('./navbar.html'),
  name: 'navbar',
  data() {
    return { token: api.token };
  },
  methods: {
    needLogin() {
      return !this.token;
    }
  }
};
