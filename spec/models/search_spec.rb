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
  let (:searched_prod)    { create(:product, category_id: searched_cat.id, name: 'generic guitar')}
  let (:search)           { create(:search, user: user, 
                                            keywords:"guitar", 
                                            category_id: searched_cat.id, 
                                            min_price: 1000, max_price: 2000) }
  
  subject{ search }
  it { should respond_to(:keywords) }
  it { should respond_to(:category_id) } 
  it { should respond_to(:min_price) }   
  it { should respond_to(:max_price) }
  
  it { should respond_to(:products) }
  
  
  describe "searched products" do
    subject { search.products }
    
    describe "when keywords include a match" do
      it { should include(searched_prod) }    
    end
  end
   
end  
