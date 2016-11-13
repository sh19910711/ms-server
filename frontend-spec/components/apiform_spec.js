import 'spec_helper';

import Vue from 'vue';
const Form = Vue.extend(require('components/apiform').default);

describe('apiform', function() {
  describe('.inputs', function() {
    beforeEach(function() {
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

  describe('.submitText', function() {
    beforeEach(function() {
      this.vm = new Form({ propsData: { submitText: 'this-is-submit' } }).$mount();
    });

    it('shows its state in submit', function() {
      const submit = this.vm.$el.querySelector('input[type="submit"]');
      expect(submit.value).toEqual('this-is-submit');
    });
  });
});
