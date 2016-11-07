import api from 'lib/api';

export default {
  components: { navbar: require('components/navbar.vue') },
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
