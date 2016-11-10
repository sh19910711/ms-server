import api from 'lib/api';

export default {
  components: { navbar: require('components/navbar.js') },
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
