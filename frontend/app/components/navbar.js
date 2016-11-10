import api from 'lib/api';

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
