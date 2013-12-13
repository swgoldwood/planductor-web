require 'spec_helper'

describe "domains/show" do
  before(:each) do
    @domain = assign(:domain, stub_model(Domain,
      :name => "Name",
      :location => "Location",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/1/)
  end
end
