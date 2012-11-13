require 'spec_helper'

describe User do
  before  { @user = create(:user, email: "user@example.com") }
  subject { @user }
  it { should respond_to(:email) }  
  it { should be_valid }
  
  describe 'when email is not present'  do 
    before { @user.email = ""}
    it { should_not be_valid }
  end 
  
  describe 'when email is already taken'  do
    before do 
      @user_with_same_email = @user.dup
      @user_with_same_email.email.upcase! 
    end
    it 'should not be valid, even with different case'  do
      @user_with_same_email.should_not be_valid   
    end 
  end 
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  
  
end

