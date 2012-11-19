# == Schema Information
#
# Table name: searches
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  keywords               :string(255)
#  category_id            :integer
#  min_price              :decimal(, )
#  max_price              :decimal(, )
#  saved                  :boolean          default(FALSE)
#  notify                 :boolean          default(FALSE)
#  notified_at            :datetime
#  new_results_presence   :boolean          default(FALSE)
#  new_results_checked_at :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe Search do 
  let (:user)             { create(:user) }
  let (:searched_cat)     { create(:category, name: "searched category")}
  let (:searched_prod)    { create(:product, category_id: searched_cat.id, 
                                             name: 'Generic Guitar match ', 
                                             price: 150000)}
  let (:search)           { create(:search, user: user) }
  
  subject{ search }
  it { should respond_to(:keywords) }
  it { should respond_to(:category_id) } 
  it { should respond_to(:min_price) }   
  it { should respond_to(:max_price) }
  
  it { should respond_to(:products) }
  
  
  describe "searched products" do
    subject { search.products }
    
    describe "when matching keywords are" do
      
      describe "unmatching" do
        before { search.keywords = "unmatch"} 
        it { should_not include(searched_prod) }
      end
      
      describe "blank" do
        before { search.keywords = "" }
        it { should include(searched_prod) }
      end
      
      describe "exact match" do
        before { search.keywords = "Generic Guitar match"}
        it { should include(searched_prod) }
      end
      
      describe "phrase match" do
        before { search.keywords = "Generic Guitar"}
        it { should include(searched_prod) }
        before { search.keywords = "Guitar match"}
        it { should include(searched_prod) }
      end
      
      describe "simple" do 
        before { search.keywords = "match"}
        it { should include(searched_prod) } 
      end 
      
      describe "multiple and adiacent" do
        before { search.keywords = "generic guitar" }
        it { should include(searched_prod) }
      end
      
      describe "multiple and unadiacent" do
        before { search.keywords = "generic match" }
        it { should include(searched_prod) }
      end
      
      describe "a substring" do
        before { search.keywords = "guit"}
        it { should include(searched_prod) }
      end
      
      describe "case unsensitive" do 
        before { search.keywords = "generic guitar match"}
        it { should include(searched_prod) }
        before { search.keywords = "guitar"}
        it { should include(searched_prod) }
        before { search.keywords = "GUITAR"}
        it { should include(searched_prod) }
        before { search.keywords = "gENERIC"}
        it { should include(searched_prod) }
        before { search.keywords = "mAtCh"}
        it { should include(searched_prod) }
      end    
      
      describe "the plural of an exact match" do
        before { search.keywords = "matches" }
        it { should include(searched_prod) }
      end
      
      describe "the singular of an exact match" do
        before do
          searched_prod.name = "Generic Guitar matches"
          search.keywords = "match"
        end    
        it { should include(searched_prod) }
      end 
      
      describe "the irregular plural of an exact match" do
        before do
          searched_prod.name = "Generic Guitar child"
          search.keywords = "children"
        end
        it { should include(searched_prod) }

        before do
          searched_prod.name = "Generic Guitar baby"
          search.keywords = "babies"
        end
        it { should include(searched_prod) }
      end
      
      describe "the irregular singular of an exact match" do 
        
        before do
          searched_prod.name = "Generic Guitar children"
          search.keywords = "child"
        end    
        it { should include(searched_prod) } 
      
        before do
          searched_prod.name = "Generic Guitar babies"
          search.keywords = "baby"
        end    
        it { should include(searched_prod) } 
        
      end
      
     
      describe "the plural of an exact match in Italian" do
        before do
          searched_prod.name = "chitarra generica"
          search.keywords = "chitarre"
        end
        it { should include(searched_prod) }
      end
      
      describe "the singular of an exact match in Italian" do
        before do
          searched_prod.name = "chitarre generiche"
          search.keywords = "chitarra"
        end    
        it { should include(searched_prod) }
      end 
      
      describe "multiple plural of an exact match in Italian" do
        before do
          searched_prod.name = "chitarra generica"
          search.keywords = "chitarre generiche"
        end
        it { should include(searched_prod) }
      end
      
      describe "multiple singular of an exact match in Italian" do
        before do
          searched_prod.name = "chitarre generiche"
          search.keywords = "chitarra generica"
        end    
        it { should include(searched_prod) }
      end
      
      describe "plural and singular of an exact match in Italian" do
        before do
          searched_prod.name = "chitarre generica"
          search.keywords = "chitarra generiche"
        end    
        it { should include(searched_prod) }
      end
          
    end 
     
    
  end
   
end  
