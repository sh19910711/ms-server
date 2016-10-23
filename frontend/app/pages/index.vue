<template lang='pug'>
  .page
    navbar

    .leading
      .leading-header
        h1.leading-title Welcome to codestand.io
      .leading-body
        p Getting started with codestand.io.

    .container
      .block
        .block-header
          h2 1. Install CLI toolchain
        .block-body
          h3 Mac OSX
          code
            | $ brew install codestand/codestand/codestand

      .block
        .block-header
          h2 2. Create and register your app
        .block-body
          code
            | $ codestand new --register led-blink

      .block
        .block-header
          h2 3. Link your device to the codestand.io
        .block-body
          code
            | $ codestand install

      .block
        .block-header
          h2 4. Deploy the app to the device
        .block-body
          code
            | $ codestand deploy
</template>

<script>
  export default { components: { navbar: require('components/navbar.vue') } }
</script>
