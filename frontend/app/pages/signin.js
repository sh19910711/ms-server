import api from 'lib/api';

export default {
  name: 'signin',
  components: { 'userform': require('components/userform.vue') },
  data: () => {
    return {
      formInputs: [
        { name: 'username', type: 'text', placeholder: 'username', },
        { name: 'password', type: 'password', placeholder: 'password' }
      ]
    };
  },
  methods: {
    formSubmit(user) {
      return api.signin(user).then(res => {
        this.$router.push('/');
      })
    }
  }
}
