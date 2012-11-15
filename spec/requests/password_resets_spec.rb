require 'spec_helper'

# Request specs (integration tests) should only be a sketch and flow of what users are actually concerned with.

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = create(:user)
    visit signin_path
    click_link "password"
    fill_in "Email", with: user.email
    click_button "Reset Password"       
    current_path.should eq(root_path)       # check the current path
    page.should have_content("Email sent")  # check Flash message 
    last_email.to.should include(user.email)
  end
end
