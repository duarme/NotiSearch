# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper   
  
	def full_title(page_title, main_title = Rails.application.class.parent_name)
		page_title.empty? ? main_title : "#{main_title} | #{page_title}"
	end
	
	def title(page_title)
	  provide(:title, page_title)
	  content_tag(:h1, page_title)
	end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
