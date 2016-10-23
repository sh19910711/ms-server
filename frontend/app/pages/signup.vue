<template lang='pug'>
  .page
    .panel
      .panel-header
        .panel-title Sign up
      .panel-body
        userform(firstState='Sign up', :inputs='formInputs', :on-submit='formSubmit')
      .panel-footer
        ul
          li
            span Have an account?&nbsp;
            router-link(to='/signin') Sign in.
          li
            router-link(to='/') Back to home
</template>

<script>
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
          api.toekn = res.headers['token']
          this.$router.push('/signin');
        });
      }
    }
  }
</script>
