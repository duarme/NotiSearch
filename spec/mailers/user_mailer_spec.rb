require "spec_helper"

describe UserMailer do
  describe "password_reset" do    
    let(:user) { create(:user, password_reset_token: "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["notisearch@example.com"])
      mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  
  describe "new_results_sets_for(user)" do
    let!(:user) { create(:user, password_reset_token: "anything") }
    let!(:search_one) { create(:search, user: user, keywords: "matching", notify: true) }
    let!(:search_two) { create(:search, user: user, keywords: "othermatch", notify: true) }
    let(:mail) { UserMailer.new_search_results_for(user) }
    
    context "when there are no new results" do
      
      it "doesn't sent notification" do
        mail.subject.should match("There are no new results")
      end  
    
    end
    
    context "whene there is one new result for one search" do
      
      let!(:product) { create(:product, name: "matching") } 
      
      it "send notification" do
        mail.subject.should match("There is 1 new result for 1 of your preferred searches")
        mail.to.should eq([user.email]) 
        mail.from.should eq(["notisearch@example.com"])
        # mail.body.encoded.should match("TODO")
      end
      
    end
    
    context "when there are tree new results for one search" do
      let!(:product_one)  { create(:product, name: "matching product one") }
      let!(:product_two)  { create(:product, name: "matching product two") }
      let!(:product_tree) { create(:product, name: "matching product tree") }
      let!(:product_four) { create(:product, name: "product four othermatch") }
      let!(:product_five) { create(:product, name: "product five othermatch") }

      
      it "sends notification" do
        mail.subject.should match("There are 5 new results for 2 of your preferred searches")
        mail.to.should eq([user.email])
        mail.from.should eq(["notisearch@example.com"]) 
      end 
      
      it "includes new results details in the notification" do
        mail.body.encoded.should match(product_one.name)
        mail.body.encoded.should match(product_two.name)
        mail.body.encoded.should match(product_tree.name)
        mail.body.encoded.should match(product_four.name)
        mail.body.encoded.should match(product_five.name)
      end
      
    end    
    
    
  end

end  
