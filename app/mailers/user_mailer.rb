class UserMailer < ActionMailer::Base
  default from: "notisearch@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end 
  
  # Fetches all new search results for every search of the passed user, collect them in the
  # @new_result_sets hash (in which the searches are the keys and the related new results are the values)
  # and then touches the notified_at attribute for every search in it
  # the email template will then use @new_result_sets to generate the email body 
  def new_search_results_for(user)
    @user = user   
    @new_result_sets = new_result_sets_for(@user.searches)
    
    touch_notified_at_for(@new_result_sets) # PERFORMANCE maybe improvable moving this in an after callback
       
    mail to: @user.email, subject: subject_content 
  end
  
  private
  
  
  # Returns a hash with searches as keys and their new_results as values
  # see Search#new_results 
  def new_result_sets_for(searches)
    new_result_sets = Hash.new
    searches.each do |s|
      # If a search has never been notified before, since notified_at is nil, 
      # the time_reference is the search created_at attribute. 
      time_reference = (s.notified_at ? s.notified_at : s.created_at)
      new_result_sets[s] = s.new_results(time_reference) if s.notify && s.new_results(time_reference).count > 0 
    end
    return new_result_sets
  end  
  
  def new_results_count
    @new_result_sets.any? ? @new_result_sets.map{|s, r| r.count}.inject(:+) : 0
  end
  
  def touch_notified_at_for(result_set)
    # PERFORMANCE improvable via single SQL update query just after this block
    result_set.each_key {|s| s.notified! }      
  end 
  
  def subject_content
    sc = "[NotiSearch] "
    if new_results_count > 0
      sc += "There #{new_results_count > 1 ? 'are' : 'is'} #{new_results_count} new #{(new_results_count > 1 ? 'results' : 'result')} for #{@new_result_sets.size} of your preferred searches" 
    else
      "There are no new results for any of your preferred searches"
    end
  end
end
