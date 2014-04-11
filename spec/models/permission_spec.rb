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
  end
end
