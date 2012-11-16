class Search < ActiveRecord::Base
    belongs_to :user

    # Asyncnchronously handled class methods
    class << self
      def check_new_results_presence
        searches = Search.where(notify: true).where(new_results_presence: false).order(:new_results_presence_checked_at).limit(CONFIG[:number_of_searches_to_be_checked_for_new_results])
        searches.each {|s| s.find_new_results}
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

    # to check if there are new results (since last notification) to be notified by email
    def new_results
      @new_results ||= find_new_results
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


  private

    def find_products
      products = Product.order(:name)
      products = products.where("name like ?", "%#{keywords}%") if keywords.present?
      products = products.where(category_id: category_id) if category_id.present?
      products = products.where("price >= ?", min_price) if min_price.present?
      products = products.where("price <= ?", max_price) if max_price.present?
      products
    end  

    def find_new_results
      # If a search has never been notified before, since notified_at is nil, 
      # the time_reference is the search updated_at attribute. 
      time_reference = self.notified_at ? self.notified_at : self.updated_at
      new_result_products = products.where("updated_at >= ?", time_reference)
      self.update_attributes(new_results_presence: new_result_products.any?, new_results_presence_checked_at: Time.now) 
      return new_result_products
    end 

    def find_recent_new_results
      products.where("updated_at >= ?", Time.now - 30.days).order('updated_at DESC')
    end
end
