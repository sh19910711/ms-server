<template>
  <div class="form-input">
    <label :for="input.name">{{input.name}}</label>
    <div v-if="isPassword()">
      <input v-model="input.value" type="password" :name="input.name" :placeholder="input.placeholder">
    </div>
    <div v-else>
      <input v-model="input.value" type="text" :name="input.name" :placeholder="input.placeholder">
    </div>
  </div>
</template>

<script>
  export default {
    name: 'userform-input',
    props: ['input'],
    methods: {
      isPassword() {
        return this.input.type === 'password';
      }
    }
  }
</script>
