require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'index' do
    let(:user) { create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('h1', text: 'Planductor Users') }

    it "should list each user" do
      User.all[0..2].each do |user|
        page.should have_selector('h4', text: user.name)
      end
    end
  end

  describe "Sign_up page" do
    before { visit sign_up_path }

    it { should have_selector('h1', text: 'Sign up form') }
    it { should have_button('Submit') }
  end
end
