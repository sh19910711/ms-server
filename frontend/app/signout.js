import api from 'lib/api';

export default {
  template: require('signout.html'),
  data() {
    return { state: 'Processing now...', error: null };
  },
  mounted() {
    api.signout().then(
      () => {
        this.state = 'OK, see you';
        this.$router.push('/');
      },
      res => {
        this.state = 'Error';
        this.error = res.statusText;
      }
    );
  }
};
