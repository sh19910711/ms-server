import api from 'js/api';

export default {
  template: require('./device_detail.html'),
  components: { navbar: require('components/navbar').default, apiform: require('components/apiform').default },
  data() {
    return {
      device: {},
      envvars: [],
      team: api.user,
      log: ''
    };
  },
  created() {
    const deviceName = this.$route.params['name'];
    api.deviceEnvvars({team: api.user, deviceName}).then(res => {
      this.envvars = res.content.envvars;
    });
    api.deviceLog({team: api.user, deviceName}).then(res => {
      this.log = res.content.log.join("<br>");
    });
  },
  methods: {
    onEnvUpdated() {
      const deviceName = this.$route.params['name'];
      api.deviceEnvvars({team: api.user, deviceName}).then(res => {
        this.envvars = res.content.envvars;
      });
    },
    onAppCreated() {
    }
  }
};
