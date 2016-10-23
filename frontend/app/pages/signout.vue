<template lang='pug'>
  .page
    .panel
      .panel-header
        .panel-title Sign out
      .panel-body
        .state {{state}}
        .message.message-error(v-if='error') {{error}}
      .panel-footer
        router-link(to='/') Home
</template>

<script>
  import API from 'lib/api';

  export default {
    data() {
      return { state: 'Processing now...', error: null }
    },
    mounted() {
      api.signout().then(
        res => {
          api.token = null;
          this.state = 'OK, see you';
          this.$root.$router.push('/');
        },
        res => {
          this.state = 'Error';
          this.error = res.statusText;
        }
      )
    }
  }
</script>
