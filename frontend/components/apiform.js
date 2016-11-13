import api from 'js/api';

export default {
  template: require('./apiform.html'),
  components: { errors: require('./apiform/errors').default },
  props: ['action', 'success-callback', 'submit-text', 'inputs'],
  data() {
    return {
      state: this.submitText,
      inputErrors: {},
      serverErrors: {}
    };
  },
  methods: {
    getParams() {
      const params = {};
      this.$el.querySelectorAll('.form-input input').forEach(input => {
        params[input.name] = input.value;
      });
      return params;
    },
    submit() {
      this.state = 'Processing...';
      api[this.action](this.getParams()).then(this.onSuccess).catch(this.onError);
    },
    onSuccess(res) {
      if (this.successCallback) {
        this.$router.push(this.successCallback);
      }
    },
    onError(err) {
      this.inputErrors = err.content && err.content.errors || {};
      this.serverErrors = {status: [err.response.statusText]};
      this.state = 'Retry';
    }
  }
};
