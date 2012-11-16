# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :products  
  
  def self.search(keywords)
    products = order(:name)
    products = products.where("name like ?", "%#{keywords}%") if keywords.present?
    products
  end
end
