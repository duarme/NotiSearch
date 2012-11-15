require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }   
    
  end                                                                   
  
  describe "signup" do                                           
    before { visit signup_path }
    let(:submit)  { "Sign Up" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit}.not_to change(User, :count)
      end
    end 
    
    describe "with valid information" do
      before do
        fill_in "Email",         with: "testuser@example.com"
        fill_in "Password",      with: "secret"
        fill_in "Confirmation",  with: "secret"  
      end   
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end      
    end
  end
  
end
