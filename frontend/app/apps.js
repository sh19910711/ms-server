import api from 'lib/api';

export default {
  components: { navbar: require('components/navbar.js') },
  data() {
    return {
      apps: []
    };
  },
  mounted() {
    api.apps(api.user).then(res => {
      this.apps = res.content.applications;
    });
  }
};
