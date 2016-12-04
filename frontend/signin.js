import api from 'js/api';

export default {
  template: require('./signin.html'),
  components: { 'apiform': require('components/apiform').default },
  data() {
    return {
      formInputs: [
        { type: 'text', name: 'name' },
        { type: 'password', name: 'password' }
      ]
    };
  }
};
