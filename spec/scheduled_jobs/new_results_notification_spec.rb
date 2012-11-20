require 'spec_helper' 

# This will cause your jobs to be processed immediately upon enqueuing, not in a separate thread.
# Delayed::Worker.delay_jobs = false  

# Another approach is to call after a delayed_job 
# successes, @failures = Delayed::Worker.new.work_off 
# to process all the job queue and then test that
# @failures.should == 0

describe Search do
  before do
    @user = create(:user)
    search_with_notification = @user.searches.create!(notify: true, saved: true, keywords: "matching")
  end 
  
  describe "Search.check_new_results_presence" do
    
    context "when there are no new results" do
      before do 
        Search.check_new_results_presence
        successes, @failures = Delayed::Worker.new.work_off
        @search = @user.searches.first
      end
      
      it "should not find new results for searches with no new results" do
        @failures.should == 0 
        @search.keywords.should == "matching"
        @search.new_results_presence.should be_false
        @search.new_results_checked_at.should_not be_nil
      end 
          
    end
    
    context "when there are new results" do 
      
      before do
        product_one = Product.create!(name: "matching") 
        product_two = Product.create!(name: "matching") 
        product_tre = Product.create!(name: "matching") 
        Search.check_new_results_presence
        successes, @failures = Delayed::Worker.new.work_off
        @search = @user.searches.first
      end 
         
      it "should find new results for searches with new results" do
        @failures.should == 0
        @search.new_results_presence.should be_true 
        @search.new_results_checked_at.should_not be_nil
        @search.new_results(@search.new_results_checked_at - 1.second).count.should == 3  
      end
    end        
    
  end
  
  
  describe "Search.notify_new_results_by_mail" do
    
      context "when there are new results to be notified" do 

        before do
          product_one = Product.create!(name: "matching") 
          product_two = Product.create!(name: "matching") 
          product_tre = Product.create!(name: "matching") 
          
          other_search = @user.searches.create!(notify: true, saved: true, keywords: "othermatch") 
          product_four = Product.create!(name: "othermatch")
          product_five = Product.create!(name: "othermatch")
          
          Search.check_new_results_presence
          successes, failures = Delayed::Worker.new.work_off
          failures.should == 0
          @search = @user.searches.first

          Search.notify_new_results_by_mail
          successes, failures = Delayed::Worker.new.work_off
          failures.should == 0
          
        end 

        it "should notify the new results to the user" do              
          last_email.to.should include(@user.email)
          last_email.subject.should match("There are 5 new results for 2 of your preferred searches")   
        end     

    end
  
  end
  
end