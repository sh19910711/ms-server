export default {
  name: 'userform-input',
  template: require('./input.html'),
  props: ['input'],
  methods: {
    isPassword() {
      return this.input.type === 'password';
    }
  }
};
