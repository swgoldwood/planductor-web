require 'spec_helper'

describe "domains/edit" do
  before(:each) do
    @domain = assign(:domain, stub_model(Domain,
      :name => "MyString",
      :location => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit domain form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", domain_path(@domain), "post" do
      assert_select "input#domain_name[name=?]", "domain[name]"
      assert_select "input#domain_location[name=?]", "domain[location]"
      assert_select "input#domain_user_id[name=?]", "domain[user_id]"
    end
  end
end
