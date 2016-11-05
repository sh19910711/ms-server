<template>
  <div class="page">
    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">Sign in</div>
      </div>
      <div class="panel-body">
        <userform firstState="Sign in" :inputs="formInputs" :on-submit="formSubmit"></userform>
      </div>
      <div class="panel-footer">
        <ul>
          <li>New to codestand.io? <router-link to="/signup">Sign up now.</router-link></li>
          <li><router-link to="/">Back to Home</router-link></li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
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
          localStorage.setItem('cs-token', api.token = res.headers['token']);
          this.$router.push('/');
        })
      }
    }
  }
</script>
