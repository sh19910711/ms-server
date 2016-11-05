<template>
  <div class="navbar">
    <div class="nav" v-if="needLogin()">
      <div class="nav-left">
        <h1 class="nav-brand"><router-link to="/">codestand.io</router-link></h1>
      </div>
      <div class="nav-right">
        <ul class="nav-list">
          <li><router-link to="/signin">Sign in</router-link></li>
          <li><router-link to="/signup">Sign up</router-link></li>
        </ul>
      </div>
    </div>

    <div class="nav" v-else>
      <div class="nav-left">
        <h1 class="nav-brand"><router-link to="/">codestand.io</router-link></h1>
      </div>
      <div class="nav-right">
        <ul class="nav-list">
          <li><router-link to="/">Home</router-link></li>
          <li><router-link to="/applications">Applications</router-link></li>
          <li><router-link to="/devises">Devises</router-link></li>
          <li><router-link to="/signout">Sign out</router-link></li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'navbar',
    data() {
      return { token: api.token };
    },
    methods: {
      needLogin() {
        return !this.token;
      }
    }
  }
</script>
