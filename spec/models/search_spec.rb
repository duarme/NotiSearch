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

require File.dirname(__FILE__) + '/../spec_helper'

describe Search do
  it "should be valid" do
    Search.new.should be_valid
  end
end
