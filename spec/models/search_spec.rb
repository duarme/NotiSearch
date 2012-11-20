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
  let (:product)          { create(:product, category_id: searched_cat.id, 
                                             name: 'Generic Guitar match ', 
                                             price: 150000)}
  let (:search)           { create(:search) }
  
  subject{ search }
  it { should respond_to(:keywords) }
  it { should respond_to(:category_id) } 
  it { should respond_to(:min_price) }   
  it { should respond_to(:max_price) } 
  it { should respond_to(:user) }
  
  it { should respond_to(:products) } 
  
  
  describe "resultset" do
    subject { search.products } 
    
    describe "when matching keywords are" do
      
      describe "unmatching" do
        let(:search) { create(:search , keywords: "unmatch") } 
        it { should_not include(product) }
      end
      
      describe "blank" do
        let(:search) { create(:search , keywords: "") } 
        it { should include(product) }
      end  
      
      describe "exact match" do
        let(:search) { create(:search , keywords: "Generic Guitar match") }
        it { should include(product) }
      end 
      
      describe "phrase match" do
        let(:search) { create(:search , keywords: "Generic Guitar") }
        it { should include(product) }
        let(:search) { create(:search , keywords: "Guitar match") }
        it { should include(product) }
      end

      describe "simple" do 
        let(:product) { create(:product, name: "Ibanez Paul Gilbert Guitar") }
        let(:search)  { create(:search , keywords: "ibanez paul gilbert") }
        it { should include(product) } 
      end  

      describe "multiple and adiacent" do
        let(:search) { create(:search , keywords: "generic guitar") }
        it { should include(product) }
      end   
           
      describe "multiple and unadiacent" do
        let(:search) { create(:search , keywords: "generic match") }
        it { should include(product) }
      end       

      describe "case unsensitive" do 
        let(:search) { create(:search , keywords: "generic guitar match") }
        it { should include(product) }
        let(:search) { create(:search , keywords: "guitar") }
        it { should include(product) }
        let(:search) { create(:search , keywords: "GUITAR") }
        it { should include(product) }
        let(:search) { create(:search , keywords: "gENERIC") }
        it { should include(product) }
        let(:search) { create(:search , keywords: "mAtCh") }
        it { should include(product) }
      end    
          
      describe "the plural of an exact match" do
        let(:search) { create(:search , keywords: "matches") }
        it { should include(product) }
      end       
            
      describe "the singular of an exact match" do
        let(:product) { create(:product, name: "Generic Guitar matches") }
        let(:search)  { create(:search , keywords: "match") }
        it { should include(product) }
      end  
            
      describe "the irregular plural of an exact match" do
        let(:product) { create(:product, name: "Guitar for a Child") }
        let(:search)  { create(:search , keywords: "guitar for children") }
        it { should include(product) }   
      
        let(:product) { create(:product, name: "Generic Guitar baby") }
        let(:search)  { create(:search , keywords: "babies") }
        it { should include(product) }
      
        let(:product) { create(:product, name: "Generic Guitar character") }
        let(:search)  { create(:search , keywords: "characters") }
        it { should include(product) }
      
        let(:product) { create(:product, name: "Generic Guitar hero") }
        let(:search)  { create(:search , keywords: "heroes") }
        it { should include(product) }
      end  
             
      describe "the irregular singular of an exact match" do 
        let(:product) { create(:product, name: "Generic Guitar children") }
        let(:search)  { create(:search , keywords: "child") }
        it { should include(product) } 
      
        let(:product) { create(:product, name: "Generic Guitar babies") }
        let(:search)  { create(:search , keywords: "baby") }
        it { should include(product) } 
      
        let(:product) { create(:product, name: "Generic Guitar characters") }
        let(:search)  { create(:search , keywords: "character") }
        it { should include(product) }
      
        let(:product) { create(:product, name: "Generic Guitar heroes") }
        let(:search)  { create(:search , keywords: "hero") }
        it { should include(product) }
      end    

      describe "including stopwords" do
        let(:product) { create(:product, name: "Generic Guitar Hero") }   
        let(:unmatching_product) { create(:product, name: "unmatching product") }
        let(:search)  { create(:search , keywords: "generic guitar of a hero") }
        it { should include(product) } 
        it { should_not include(unmatching_product) }
      end     
      
      describe "the plural of an exact match in Italian" do
        let(:product) { create(:product, name: "chitarra generica") } 
        let(:user)    { create(:user, language: "italian") }
        let(:search)  { create(:search, user: user, keywords: "chitarre") }
        it { should include(product) }
      end  
      
      describe "the singular of an exact match in Italian" do 
        let(:product) { create(:product, name: "chitarre generiche") }
        let(:user)    { create(:user, language: "italian") }
        let(:search)  { create(:search, user: user, keywords: "chitarra") }
        it { should include(product) }
      end 
      
      describe "multiple plural of an exact match in Italian" do  
        let(:product) { create(:product, name: "chitarra generica") }
        let(:user)    { create(:user, language: "italian") }
        let(:search)  { create(:search, user: user, keywords: "chitarre generiche") }
        it { should include(product) }
      end
      
      describe "multiple singular of an exact match in Italian" do
        let(:product) { create(:product, name: "chitarre generiche") } 
        let(:user)    { create(:user, language: "italian") }
        let(:search)  { create(:search, user: user, keywords: "chitarra generica") }
        it { should include(product) }
      end
      
      describe "plural and singular of an exact match in Italian" do
        let(:product) { create(:product, name: "chitarre generiche") }
        let(:user)    { create(:user, language: "italian") }
        let(:search)  { create(:search, user: user, keywords: "chitarra generiche") }
        it { should include(product) }
      end     
      
    end
    
    context "full-text search in product name and description" do
       describe "when matching terms are only in the description" do 
         let(:product) { create(:product, name: 'anything', description: "matching description")}
         let(:search) { create(:search, keywords: "matching description") }
         it { should include(product) } 
       end
     end  

     context "ranking" do    

       describe "when product name has a higher weight than product description" do
         let!(:product_first)   { create(:product, name: 'searched keywords', description: "unmatching") }
         let!(:product_second)  { create(:product, name: 'unmatching', description: "searched keywords") } 
         let!(:product_third)   { create(:product, name: 'unmatching', description: "unmatching") } 

         let(:search) { create(:search, keywords: "searched keywords") }

         it { should have(2).results }
         it { should_not == [product_second, product_first] }
         it { should == [product_first, product_second] }
         it { should include(product_first) }     
         it { should include(product_first) }   
         it { should include(product_second) }    
         it { should_not include(product_third) }   
       end                                      

       describe "should order product by ranking" do 
         let!(:product_third)   { create(:product, name: 'product name unmatching', description: "product description matching") }
         let!(:product_first)   { create(:product, name: 'product name matching',   description: "product description matching") }
         let!(:product_second)  { create(:product, name: 'product name matching',   description: "product description unmatching") } 

         let!(:search) { create(:search, keywords: "matching") } 

         it { should have(3).results}  
         it { should_not == [product_third, product_first, product_second] } 
         it { should == [product_first, product_second, product_third] } 
       end

       describe "should order product by ranking #2" do 
         let!(:product_third)   { create(:product, name: 'product name unmatching', description: "matching product matching description matching") }
         let!(:product_first)   { create(:product, name: 'product name matching',   description: "product description matching") }
         let!(:product_second)  { create(:product, name: 'product name matching',   description: "product description unmatching") } 

         let!(:search) { create(:search, keywords: "matching") } 

         it { should have(3).results}  
         it { should_not == [product_third, product_first, product_second] } 
         it { should == [product_first, product_second, product_third] } 
       end           

     end 
    
  end
   
end  
