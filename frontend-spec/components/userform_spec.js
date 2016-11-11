import 'spec_helper';
var Vue = require('vue');

describe('userform', function() {
  describe('.inputs', function() {
    beforeEach(function() {
      const Form = Vue.extend(require('components/userform').default);
      const inputs = [
        { type: 'text', name: 'this-is-text' },
        { type: 'password', name: 'this-is-password' }
      ];
      this.vm = new Form({ propsData: {inputs} }).$mount();
    });

    it('shows text input', function() {
      const el = this.vm.$el.querySelector('input[type="text"]');
      expect(el.name).toEqual('this-is-text');
    });

    it('shows password input', function() {
      const el = this.vm.$el.querySelector('input[type="password"]');
      expect(el.name).toEqual('this-is-password');
    });
  });

  describe('.firstState', function() {
    beforeEach(function() {
      const Form = Vue.extend(require('components/userform').default);
      this.vm = new Form({ propsData: { firstState: 'this-is-state' } }).$mount();
    });

    it('shows its state on a button', function() {
      expect(this.vm.$el.querySelector('.button').text).toEqual('this-is-state');
    });
  });

  describe('.onSubmit', function() {
    beforeEach(function() {
      const Form = Vue.extend(require('components/userform').default);
      this.spy = sinon.spy(() => new Promise(resolve => resolve()));
      this.vm = new Form({ propsData: { inputs: [], onSubmit: this.spy } }).$mount();
    });

    it('is called by submit()', function(done) {
      this.vm.$el.querySelector('.button').click();
      Vue.nextTick(() => {
        expect(this.spy.calledOnce).toBeTruthy();
        done();
      });
    });
  });
});
