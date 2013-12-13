require 'spec_helper'

describe "domains/new" do
  before(:each) do
    assign(:domain, stub_model(Domain,
      :name => "MyString",
      :location => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new domain form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", domains_path, "post" do
      assert_select "input#domain_name[name=?]", "domain[name]"
      assert_select "input#domain_location[name=?]", "domain[location]"
      assert_select "input#domain_user_id[name=?]", "domain[user_id]"
    end
  end
end
