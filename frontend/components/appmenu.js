export default {
  template: require('./appmenu.html'),
  props: ['active', 'base'],
  mounted() {
    const el = this.$el.querySelector(`[data-href="${this.active}"]`);
    if (el) {
      el.dataset.active = 'true';
    }
  },
  methods: {
    show(ev) {
      let href = `/apps/${this.$route.params['name']}`;
      if (ev.target.dataset.href) href += `/${ev.target.dataset.href}`
      if (this.base) href = this.base + href;
      this.$router.push(href);
    }
  }
};
