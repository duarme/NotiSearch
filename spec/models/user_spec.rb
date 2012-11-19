# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  password_digest        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  language               :string(255)
#

require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  let(:user_on_create) { User.new(email: user.email, password: user.password, password_confirmation: user.password_confirmation) }
  subject { user }
  it { should respond_to(:email) } 
  it { should respond_to(:password_digest) }   
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }   
  it { should respond_to(:authenticate) }
  it { should be_valid }
  
  #User#email
  describe 'when email is not present'  do 
    before { user.email = ""}
    it { should_not be_valid }
  end 
  
  describe 'when email is already taken'  do
    let(:user_with_same_email) do 
      user_with_same_email = user.dup 
      user_with_same_email.email.upcase! 
      user_with_same_email
    end     
    it 'should not be valid, even with different case'  do
      user_with_same_email.should_not be_valid   
    end 
  end 
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        user.should be_valid
      end      
    end
  end
  
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      user.email = mixed_case_email
      user.save
      user.reload.email.should == mixed_case_email.downcase
    end
  end  
  
  # User passwords

    context "User on create" do
      subject { user_on_create }
      
      describe "when password is not present" do
        before { user_on_create.password = user.password_confirmation = " " }
        it { should_not be_valid }
      end

      describe "when password doesn't match confirmation" do
        before { user_on_create.password_confirmation = "mismatch" }
        it { should_not be_valid }
      end

      describe "when password confirmation is nil" do
        before { user_on_create.password_confirmation = nil }
        it { should_not be_valid }
      end   

      describe "with a password that's too short" do
        before { user_on_create.password = user_on_create.password_confirmation = "a" * 4 }
        it { should_not be_valid }
      end
      
    end
    

  
  describe "#send_password_reset" do
    
    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end                                                  
    
    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end                                                   
    
    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end
  
  # User#authenticate
  describe "return value of authenticate method" do
    before { user.save }
    let(:found_user) { User.find_by_email(user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  
end

