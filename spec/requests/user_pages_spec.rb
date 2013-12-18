require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'index' do
    let(:user) { create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('h1', text: 'Planductor Users') }
  end
end
