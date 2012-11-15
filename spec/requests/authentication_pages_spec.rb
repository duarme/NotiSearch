require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: full_title('Sign in')) }
  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before do
        fill_in "Email",    with: 'foobar@example.com'
        fill_in "Password", with: 'foobar'
        click_button "Sign in"
      end
      it { should have_selector('title', text: full_title('Sign in'))}
      it { should have_selector('div#flash_error', text: 'Invalid email/password combination')}
    end  
    
    describe "with valid information" do
      let(:user) { create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end                     
      
      it { should     have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in',  href: signin_path) }
    end
    
    
  end
  
end
