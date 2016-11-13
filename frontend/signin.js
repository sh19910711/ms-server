import api from 'js/api';
import User from 'stores/user';

export default {
  name: 'signin',
  template: require('./signin.html'),
  components: { 'apiform': require('components/apiform').default },
  data() {
    return {
      formInputs: [
        { type: 'text', name: 'username' },
        { type: 'password', name: 'password' }
      ]
    };
  }
};
