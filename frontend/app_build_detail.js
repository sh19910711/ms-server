import api from 'js/api';

export default {
  template: require('./app_build_detail.html'),
  components: {
    navbar: require('components/navbar').default,
    appmenu: require('components/appmenu').default
  },
  data() {
    return {
      log: 'loading...'
    };
  },
  created() {
    api.send('get', `/api/${api.user}/apps/${this.$route.params['name']}/builds/${this.$route.params['build_id']}`).then(res => {
      this.log = this.format(res.content.log);
    })
  },
  methods: {
    // TODO
    format(txt) {
      return txt
        .replace(/\n/g, '<br>').replace(/ /g, "&nbsp;")
        .replace(/\033\[1;35m/g, '<span style="color: rgba(249, 53, 248, 1);">')
        .replace(/\033\[0;33m/g, '<span style="color: grey;">')
        .replace(/\033\[m/g, '<span style="color: grey;">');
    }
  }
};
