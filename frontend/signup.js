import api from 'js/api';

export default {
  name: 'signup',
  template: require('signup.html'),
  components: { 'userform': require('components/userform').default },
  data: () => {
    return {
      formInputs: [
        { name: 'email', type: 'text', placeholder: 'E-mail (e.g. brine@example.com)' },
        { name: 'name', type: 'text', placeholder: 'Username (e.g, brine)', },
        { name: 'password', type: 'password', placeholder: 'Password (at least 8 characters)' }
      ]
    };
  },
  methods: {
    formSubmit(params) {
      return api.signup(params).then(() => {
        this.$router.push('/signin');
      });
    }
  }
};
