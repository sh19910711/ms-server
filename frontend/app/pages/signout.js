import api from 'lib/api';

export default {
  data() {
    return { state: 'Processing now...', error: null }
  },
  mounted() {
    api.signout().then(
      res => {
        this.state = 'OK, see you';
        this.$router.push('/');
      },
      res => {
        this.state = 'Error';
        this.error = res.statusText;
      }
    )
  }
}
