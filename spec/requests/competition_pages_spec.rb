require 'spec_helper'

describe 'Competition pages' do
  subject { page }

  describe 'index' do
    let(:user) { create(:user) }
    let(:organiser) { create(:organiser) }

    before { visit competitions_path }

    it { should have_selector('h1', text: 'Competitions') }

    describe 'for normal users' do
      before do
        sign_in user 
        visit competitions_path
      end

      it { should_not have_link('New Competition') }
    end

    describe 'for organiser user' do
      before do
        sign_in organiser
        visit competitions_path
      end

      it { should have_link('New Competition') }
    end
  end

end
