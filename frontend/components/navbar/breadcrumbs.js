import api from 'js/api';

export default {
  template: require('./breadcrumbs.html'),
  props: ['teams', 'path'],
  data() {
    let crumbLink = '';
    const path = this.$route && this.$route.path || '';
    return {
      team: api.user,
      crumbs: path.substr(1).split('/').map(crumb => {
        crumbLink += `/${crumb}`;
        return {
          name: crumb,
          link: crumbLink
        };
      })
    };
  }
};
