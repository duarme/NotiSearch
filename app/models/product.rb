# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  category_id :integer
#  price       :decimal(, )
#  released_at :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ActiveRecord::Base
  attr_accessible :name, :category, :category_id, :price, :released_at 
  belongs_to :category 
  
  def self.search(keywords)
    products = order(:name)
    products = products.where("name like ?", "%#{keywords}%") if keywords.present?
    products
  end
end
