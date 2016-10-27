import 'spec_helper';

describe('navbar', function() {
  describe('.token', function() {
    beforeEach(function() {
      this.vm = new Vue(require('components/navbar.vue')).$mount();
    });

    it('shows link to signin if not defined', function(done) {
      this.vm.token = false; // TODO: use yet another state
      expect(this.vm.needLogin()).toBeTruthy();

      Vue.nextTick(() => {
        expect(this.vm.$el.querySelector('router-link[to="/signin"]')).toBeTruthy();
        expect(this.vm.$el.querySelector('router-link[to="/signout"]')).toBeFalsy();
        done();
      });
    });

    it('shows link to signout if defined', function(done) {
      this.vm.token = true;
      expect(this.vm.needLogin()).toBeFalsy();

      Vue.nextTick(() => {
        expect(this.vm.$el.querySelector('router-link[to="/signin"]')).toBeFalsy();
        expect(this.vm.$el.querySelector('router-link[to="/signout"]')).toBeTruthy();
        done();
      });
    });
  });
});
