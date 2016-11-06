<template>
  <div class="page">
    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">Sign out</div>
      </div>
      <div class="panel-body">
        <div class="state">{{state}}</div>
        <div class="message message-error" v-if="error">{{error}}</div>
      </div>
      <div class="panel-footer">
        <router-link to="/">Home</router-link>
      </div>
    </div>
  </div>
</template>

<script>
  import api from 'lib/api';

  export default {
    data() {
      return { state: 'Processing now...', error: null }
    },
    mounted() {
      api.signout().then(
        res => {
          this.state = 'OK, see you';
          this.$router.push('/');
        },
        res => {
          this.state = 'Error';
          this.error = res.statusText;
        }
      )
    }
  }
</script>
