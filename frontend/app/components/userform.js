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
        res => { this.state = 'OK'; return res; },
        err => {
          this.inputErrors = err.content && err.content.errors || {};
          this.serverErrors = {status: err.response.statusText};
          this.state = 'Retry';
        }
      );
    }
  }
}
