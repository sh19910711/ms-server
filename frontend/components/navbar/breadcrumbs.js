import api from 'js/api';

export default {
  template: require('./breadcrumbs.html'),
  props: ['teams', 'path'],
  data() {
    let crumbLink = '';
    return {
      team: api.user,
      crumbs: this.$route.path.substr(1).split('/').map(crumb => {
        crumbLink += `/${crumb}`;
        return {
          name: crumb,
          link: crumbLink
        };
      })
    };
  }
};
