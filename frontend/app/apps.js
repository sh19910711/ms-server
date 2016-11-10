import api from 'lib/api';

export default {
  components: { navbar: require('components/navbar').default },
  template: require('apps.html'),
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
