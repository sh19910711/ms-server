import api from 'js/api';

export default {
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
