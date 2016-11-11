export default {
  template: require('./appmenu.html'),
  props: ['active', 'base'],
  mounted() {
    if (this.active) {
      if (this.lastActiveElement) this.lastActiveElement.dataset.active = 'false';
      const el = this.$el.querySelector(`[data-href="${this.active}"]`);
      el.dataset.active = 'true';
      this.lastActiveElement = el;
    }
  },
  methods: {
    show(ev) {
      let href = ev.target.dataset.href;
      if (this.base) href = this.base + href;
      this.$router.push(href);
    }
  }
};
