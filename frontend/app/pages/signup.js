import api from 'lib/api';

export default {
  name: 'signup',
  components: { 'userform': require('components/userform.vue') },
  data: () => {
    return {
      formInputs: [
        { name: 'email', type: 'text', placeholder: 'e.g., brine@example.com' },
        { name: 'name', type: 'text', placeholder: 'e.g., brine', },
        { name: 'password', type: 'password', placeholder: 'at least 8 characters' }
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
