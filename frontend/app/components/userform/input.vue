<template lang='pug'>
  .form-input
    label(:for='input.name') {{input.name}}
    div(v-if='input.type === \'password\'')
      input(v-model='input.value', type='password', :name='input.name', :placeholder='input.placeholder')
    div(v-else)
      input(v-model='input.value', type='text', :name='input.name', :placeholder='input.placeholder')
</template>

<script>
  export default {
    name: 'userform-input',
    props: ['input'],
  }
</script>
