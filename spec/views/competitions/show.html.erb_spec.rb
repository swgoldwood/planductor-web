require 'spec_helper'

describe "competitions/show" do
  before(:each) do
    @competition = assign(:competition, stub_model(Competition,
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
