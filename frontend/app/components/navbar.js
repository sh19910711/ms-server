import api from 'lib/api';

export default {
  name: 'navbar',
  data() {
    return { token: api.token };
  },
  methods: {
    needLogin() {
      return !this.token;
    }
  }
}
