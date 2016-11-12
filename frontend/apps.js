import api from 'js/api';

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
      this.apps = res.content.applications.map(app => {
        app.url = `/apps/${app.name}`;
        return app;
      });
    });
  },
  methods: {
    show(ev) {
      this.$router.push(ev.target.dataset.href);
    }
  }
};
