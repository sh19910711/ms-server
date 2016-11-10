import api from 'lib/api';

export default {
  name: 'signin',
  components: { 'userform': require('components/userform.vue') },
  data: () => {
    return {
      formInputs: [
        { name: 'username', type: 'text', placeholder: 'Username', },
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