class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  # has_secure_password
  
  before_save { |user| user.email = email.downcase }                                   
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: {with: VALID_EMAIL_REGEX}
  # validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  # validates_presence_of :password, on: :create
  # validates_length_of :password, minimum: 4, allow_blank: true

  # def self.authenticate(username, password)
  #   user = find_by_username(username)
  #   return user if user && user.authenticate(password)
  # end 
end
