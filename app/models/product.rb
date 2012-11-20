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

class Product < ActiveRecord::Base
  attr_accessible :name, :category, :category_id, :price, :released_at 
  belongs_to :category
  
  # include PgSearch
  # pg_search_scope :search, against: [:name],
  #   using: {tsearch: {dictionary: "english"}} 
  #   # ignoring: :accents    
    

  def self.advanced_search(query, dictionary = "english")  
    if query.present? 
      rank = <<-RANK 
        ts_rank(to_tsvector('#{dictionary}', name), plainto_tsquery('#{dictionary}', #{sanitize(query)})) +
        ts_rank(to_tsvector('#{dictionary}', description), plainto_tsquery('#{dictionary}', #{sanitize(query)}))*0.7  
      RANK
      where("to_tsvector('#{dictionary}', name) @@ plainto_tsquery('#{dictionary}', :q) OR to_tsvector('#{dictionary}', description) @@ plainto_tsquery('#{dictionary}', :q)", q: query).order("#{rank} desc")
    else
      scoped
    end
  end  


     
end
