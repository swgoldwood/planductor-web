require 'spec_helper'

describe "domains/index" do
  before(:each) do
    assign(:domains, [
      stub_model(Domain,
        :name => "Name",
        :location => "Location",
        :user_id => 1
      ),
      stub_model(Domain,
        :name => "Name",
        :location => "Location",
        :user_id => 1
      )
    ])
  end

  it "renders a list of domains" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
