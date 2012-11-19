# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  category_id :integer
#  price       :integer
#  released_at :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

# require File.dirname(__FILE__) + '/../spec_helper'
# 
# describe Product do
#   it "should be valid" do
#     Product.new.should be_valid
#   end
# end    
