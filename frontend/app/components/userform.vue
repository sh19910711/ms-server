<template>
  <form class="form" v-on:submit.prevent="submit">
    <div class="form-control" v-for="input in inputs">
      <userform-input :input="input"></userform-input>
      <div class="form-errors" v-if="inputErrors[input.name] && inputErrors[input.name].length">
        <div class="form-errors-message">ERR: {{inputErrors[input.name]}}</div>
      </div>
    </div>

    <div class="form-control">
      <a class="button button-success" v-on:click="submit">{{state}}</a>
    </div>

    <div class="form-errors">
      <div class="form-errors-message" v-if="serverErrors['status']">ERROR: {{serverErrors['status']}}</div>
    </div>
  </div>
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
        const params = this.inputs.reduce((v, i) => { v[i.name] = i.value; return v }, {});
        this.onSubmit(params).then(
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
