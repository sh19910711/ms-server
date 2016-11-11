export default {
  template: require('./appmenu.html'),
  props: ['active'],
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
      this.$router.push(ev.target.dataset.href);
    }
  }
};
