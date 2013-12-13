require 'spec_helper'

describe "competitions/edit" do
  before(:each) do
    @competition = assign(:competition, stub_model(Competition,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit competition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", competition_path(@competition), "post" do
      assert_select "input#competition_name[name=?]", "competition[name]"
      assert_select "textarea#competition_description[name=?]", "competition[description]"
    end
  end
end
