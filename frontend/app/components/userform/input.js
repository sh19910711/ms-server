export default {
  name: 'userform-input',
  props: ['input'],
  methods: {
    isPassword() {
      return this.input.type === 'password';
    }
  }
}
