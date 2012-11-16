class SearchesController < ApplicationController
  # user needs to login before perform advanced searches 
  # TODO before_filter to ensure current_user can CRUD only his own searches
  before_filter :authenticate_user!
  
  def new
    @search = current_user.searches.new
  end
  
  def create
    @search = current_user.searches.create!(params[:search])
    redirect_to @search
  end
  
  def show
    @search = Search.find(params[:id])
  end 
  
  def index
    @searches = current_user.searches 
  end  
  
  def edit
    @search = Search.find(params[:id])
  end 
  
  def update
    @search = Search.find(params[:id])
    @search.notified_at = nil # an updated search has never been notified before
    if @search.update_attributes(params[:search])
        flash[:notice] = "Search updated"
        redirect_to searches_path 
     else
       render action: "edit" 
    end
  end 
  
  def destroy
    @search = Search.find(params[:id])  
    @search.destroy     
    flash[:notice] = "Search destroyed."
    redirect_to searches_path
  end
  
  def toggle_notification
    @search = Search.find(params[:id])
    @search.toggle_notify!
    notice = "Mail notification #{@search.notify ? 'activated' : 'deactivated'}."
    respond_to do |format|
      format.html { flash[:notice] = notice; redirect_to searches_path }
      format.js   { flash.now[:notice] = notice }
    end
  end
  
  def notify_new_results
    SearchNotifier.delay(queue: 'users-preferred-searches-new-results-newsletter').new_search_results_for(current_user)
    redirect_to root_path
  end 

 
end
