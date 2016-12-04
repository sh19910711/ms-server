require 'rails_helper'

describe 'Authentication', type: :request do
  describe '#sign_up' do
    let(:new_user) { build(:user) }
    it 'should create an user' do
      expect(User.where(name: new_user.name)).not_to be_exists
      post(user_registration_path(name: new_user.name, email: new_user.email, password: new_user.password))
      expect(response).to be_ok
      expect(User.where(name: new_user.name)).to be_exists
    end
  end

  describe '#sign_in' do
    context 'with name and password' do
      let(:user) { create(:user) }
      before { post(new_user_session_path(name: user.name, password: user.password)) }
      it { expect(response).to be_ok }
      it { expect(response.headers['access-token']).to be_present }
    end

    context 'with name and wrong password' do
      let(:user) { create(:user) }
      before { post(new_user_session_path(name: user.name, password: 'wrong')) }
      it { expect(response).not_to be_ok }
      it { expect(response.headers['access-token']).not_to be_present }
    end
  end
end
