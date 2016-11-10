import api from 'js/api';

export default {
  components: { navbar: require('components/navbar').default },
  template: require('devices.html'),
  data() {
    return {
      devices: []
    };
  },
  mounted() {
    api.devices(api.user).then(res => {
      this.devices = res.content.devices;
    });
  }
};
