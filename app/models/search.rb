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

class Search < ActiveRecord::Base 
  attr_accessible :keywords, :category_id, :min_price, :max_price, :new_results_presence, :new_results_checked_at, :saved, :notify, :notified_at
  belongs_to :user

  # Asyncnchronously handled class methods
  class << self 
    # Checks new results presence to be notified only for serches with notify: true, new_results_presence: false
    def check_new_results_presence
      searches = Search.where(notify: true).where(new_results_presence: false).order(:new_results_checked_at).limit(CONFIG[:number_of_searches_to_be_checked_for_new_results])
      # for each searches checks new results since last check
      searches.each {|s| s.new_results(s.new_results_checked_at)}
    end
    handle_asynchronously :check_new_results_presence, queue: 'searches-check-new-results-presence', priority: 5

    def notify_new_results_by_mail
      # fetch users to be notified    
      searches = Search.select('DISTINCT searches.user_id, searches.notified_at').where(new_results_presence: true).order(:notified_at).limit(CONFIG[:max_daily_emails])
      # notify users 
      searches.each {|s| UserMailer.delay(queue: 'searches-newsletters-delivering', priority: 1).new_search_results_for(s.user)}
    end
    handle_asynchronously :notify_new_results_by_mail, queue: 'searches-newsletters-processing', priority: 0

    def clear_unsaved
      Search.where(saved: false).where('updated_at < ?', Time.now - CONFIG[:search_life_in_days].days).destroy_all
    end
    handle_asynchronously :clear_unsaved, queue: 'searches-clear-unsaved', priority: 10 
  end

  # TODO
  # If a search is to be notified, then it should aslo be saved
  # If a search is deleted from preferred ones, than it cannot be notified anymore

  def products
    @products ||= find_products
  end 

  # checks new results since time_reference
  def new_results(time_reference = self.updated_at)
    @new_results ||= find_new_results(time_reference)
  end  

  # called from views to show recent new results 
  def recent_new_results
    @recent_new_results ||= find_recent_new_results
  end

  def toggle_notify!
    self.notify = !self.notify
    self.saved  = true if self.notify
    self.save!
  end 
   
  # This must be call whenever a search is notified by mail to set new_results_presence to false
  def notified!
    now = Time.now
    self.update_attributes(notified_at: now, new_results_presence: false, new_results_checked_at: now)    
  end
  
  private
  
    def find_new_results(time_reference)
      new_result_products = products.where("updated_at >= ?", time_reference)
      # update new_result_presence and checked_at if needed 
      # note that new_results_presence in this method can go from false to true but cannot go from true to false
      # only after the new search results are notified by mail is set back to false calling Search#notified!
      self.update_attributes(new_results_presence: new_result_products.any?, new_results_checked_at: Time.now) unless new_results_presence 
      return new_result_products
    end 
    

    def find_products
      products = Product.order(:name)
      products = products.where("name like ?", "%#{keywords}%") if keywords.present?
      products = products.where(category_id: category_id) if category_id.present?
      products = products.where("price >= ?", min_price) if min_price.present?
      products = products.where("price <= ?", max_price) if max_price.present?
      products
    end  

    def find_recent_new_results
      products.where("updated_at >= ?", Time.now - 30.days).order('updated_at DESC')
    end  
end
