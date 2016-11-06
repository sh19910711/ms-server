<template>
  <div class="page">
    <navbar></navbar>
    <div class="container apps">
      <div class="app" v-for="app in apps">
        <h2 class="app-name">{{app.name}}</h2>
        <div class="app-right">
          <div class="app-right-box app-status">
            <div class="app-right-box-header">Status</div>
            <div class="app-right-box-body">OK</div>
          </div>
          <div class="app-right-box app-devices">
            <div class="app-right-box-header">Devices</div>
            <div class="app-right-box-body">3</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import api from 'lib/api';

  export default {
    components: { navbar: require('components/navbar.vue') },
    data() {
      return {
        apps: []
      };
    },
    mounted() {
      console.log('hello');
      api.apps(api.user).then(res => {
        this.apps = res.content.applications;
      });
    }
  };
</script>
