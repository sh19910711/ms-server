<template>
  <div class="page">
    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">Sign up</div>
      </div>
      <div class="panel-body">
        <userform firstState="Sign up" :inputs="formInputs" :on-submit="formSubmit"></userform>
      </div>
      <div class="panel-footer">
        <ul>
          <li>Have an account? <router-link to="/signin">Sign in.</router-link></li>
          <li><router-link to="/">Back to home</router-link></li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
  import api from 'lib/api';

  export default {
    name: 'signup',
    components: { 'userform': require('components/userform.vue') },
    data: _=> {
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
        return api.signup(params).then(res => {
          this.$router.push('/signin');
        });
      }
    }
  }
</script>
