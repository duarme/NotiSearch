class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  
  before_save { |user| user.email = email.downcase }                                   
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true, 
                       length: { minimum: 5 }#, on: :create 
  validates :password_confirmation, presence: true

end
