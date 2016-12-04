import 'spec_helper';
var Vue = require('vue');

describe('navbar', function() {
  describe('.team', function() {
    beforeEach(function() {
      this.vm = new Vue(require('components/navbar').default).$mount();
    });

    it('shows link to signin if not defined', function(done) {
      this.vm.team = false; // TODO: use yet another state
      expect(this.vm.needLogin()).toBeTruthy();

      Vue.nextTick(() => {
        expect(this.vm.$el.querySelector('router-link[to="/signin"]')).toBeTruthy();
        expect(this.vm.$el.querySelector('router-link[to="/signout"]')).toBeFalsy();
        done();
      });
    });

    it('shows link to signout if defined', function(done) {
      this.vm.team = true;
      expect(this.vm.needLogin()).toBeFalsy();

      Vue.nextTick(() => {
        expect(this.vm.$el.querySelector('router-link[to="/signin"]')).toBeFalsy();
        expect(this.vm.$el.querySelector('router-link[to="/signout"]')).toBeTruthy();
        done();
      });
    });
  });
});

