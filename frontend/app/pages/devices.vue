<template>
  <div class="page">
    <navbar></navbar>

    <div class="container devices">
      <div class="table-filter">
        <input type="text" disabled>
        <button class="button" disabled>Filter</button>
      </div>
      <table class="table">
        <thead class="table-header">
          <tr>
            <th><input type="checkbox" disabled></th>
            <th>Name</th>
            <th>Board</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody class="table-body">
          <tr class="device" v-for="device in devices">
            <td><input type="checkbox" disabled></td>
            <td class="device-name">{{device.name}}</td>
            <td class="device-board">{{device.board}}</td>
            <td class="device-status">{{device.status}}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
  import api from 'lib/api';

  export default {
    components: { navbar: require('components/navbar.vue') },
    data() {
      return {
        devices: []
      };
    },
    mounted() {
      api.devices(api.user).then(res => {
        this.devices = res.content.devices;
      });
    }
  };
</script>
