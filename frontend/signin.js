import api from 'js/api';

export default {
  name: 'signin',
  template: require('./signin.html'),
  components: { 'userform': require('components/userform').default },
  data: () => {
    return {
      formInputs: [
        { name: 'username', type: 'text', placeholder: 'Username' },
        { name: 'password', type: 'password', placeholder: 'Password' }
      ]
    };
  },
  methods: {
    formSubmit(user) {
      return api.signin(user).then(() => {
        this.$router.push('/');
      });
    }
  }
};
