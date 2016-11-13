import api from 'js/api';

export default {
  template: require('./app_overview.html'),
  components: {
    navbar: require('components/navbar').default,
    appmenu: require('components/appmenu').default
  },
  data() {
    return {
      team: api.user,
      builds: [],
      deployments: []
    };
  },
  created() {
    api.appBuilds(api.user, this.$route.params['name']).then(res => {
      this.builds = res.content.builds;
    });
    api.appDeployments(api.user, this.$route.params['name']).then(res => {
      this.deployments = res.content.deployments;
    });
  }
};
