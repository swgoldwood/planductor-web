require 'spec_helper'

RSpec::Matchers.define :allow_permission do |*args|
  match do |permission|
    permission.allow?(*args).should be_truthy
  end
end

describe Permission do
  describe 'as guest' do
    subject { Permission.new(nil) }

    it { should allow_permission(:competitions, :index) }
    it { should allow_permission(:domains, :index) }
    it { should allow_permission(:sessions, :new) }
    it { should allow_permission(:users, :new) }

    it { should_not allow_permission(:competitions, :new) }
    it { should_not allow_permission(:competitions, :destroy) }
    it { should_not allow_permission(:domains, :new) }
    it { should_not allow_permission(:users, :destroy) }
  end

  describe 'as organiser' do
    let(:user) { create(:organiser) }

    subject { Permission.new(user) }

    it { should allow_permission(:domains, :new) }
    it { should allow_permission(:competitions, :new) }
    it { should allow_permission(:experiments, :new) }
  end

  describe 'as admin' do
    let(:user) { create(:admin) }

    subject { Permission.new(user) }

    it { should allow_permission(:competitions, :new) }
    it { should allow_permission(:domains, :new) }
    it { should allow_permission(:domains, :anything) }
    it { should allow_permission(:absolutely, :anything) }
  end
end
