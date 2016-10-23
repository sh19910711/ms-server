<template lang='pug'>
  .page
    .panel
      .panel-header
        .panel-title Sign in
      .panel-body
        userform(firstState='Sign in', :inputs='formInputs', :on-submit='formSubmit')
      .panel-footer
        ul
          li
            span New to codestand.io?&nbsp;
            router-link(to='/signup') Sign up now.
          li
            router-link(to='/') Back to home
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
