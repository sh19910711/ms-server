<template>
  <div class="page">
    <navbar></navbar>

    <div class="leading">
      <div class="leading-header">
        <h1 class="leading-title">Welcome to codestand.io</h1>
      </div>
      <div class="leading-body">
        <p>Getting started with codestand.io.</p>
      </div>
    </div>

    <div class="container">
      <div class="block">
        <div class="block-header">
          <h2>1. Install CLI toolchain</h2>
        </div>
        <div class="block-body">
          <h3>Mac OSX</h3>
          <code>
            $ brew install codestand/codestand/codestand
          </code>
        </div>
      </div>

      <div class="block">
        <div class="block-header">
          <h2>2. Create and register your app</h2>
        </div>
        <div class="block-body">
          <code>
            $ codestand new --register led-blink
          </code>
        </div>
      </div>

      <div class="block">
        <div class="block-header">
          <h2>3. Link your device to the codestand.io</h2>
        </div>
        <div class="block-body">
          <code>
            $ codestand install
          </code>
        </div>
      </div>

      <div class="block">
        <div class="block-header">
          <h2>4. Deploy the app to the device</h2>
        </div>
        <div class="block-body">
          <code>
            $ codestand deploy
          </code>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default { components: { navbar: require('components/navbar.vue') } }
</script>
