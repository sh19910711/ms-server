<template lang='pug'>
  form.form(v-on:submit.prevent='submit')
    .form-control(v-for='input in inputs')
      userform-input(:input='input')
      .form-errors(v-if='inputErrors[input.name] && inputErrors[input.name].length')
        .form-errors-message ERR: {{inputErrors[input.name]}}

    .form-control
      a.button.button-success(v-on:click='submit') {{state}}

    .form-errors
      .form-errors-message(v-if="serverErrors['status']") ERROR: {{serverErrors['status']}}
</template>

<script>
  export default {
    name: 'userform',
    components: { userformInput: require('./userform/input.vue') },
    props: ['on-submit', 'first-state', 'inputs'],
    data() {
      return {
        state: this.firstState,
        inputErrors: {},
        serverErrors: {}
      };
    },
    methods: {
      submit() {
        this.state = 'Processing...'
        this.onSubmit(this.inputs.reduce((v, i) => { v[i.name] = i.value; return v }, {})).then(
          res => { this.state = 'OK'; },
          res => {
            this.inputErrors = res.body && res.body.errors || {};
            this.serverErrors = {status: res.statusText};
            this.state = 'Retry';
          }
        );
      }
    }
  }
</script>
