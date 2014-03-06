class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :organiser, :admin
  attr_accessor :password, :password_confirmation

  has_many :planners, dependent: :destroy
  has_many :domains
  has_many :competitions, dependent: :destroy

  validates_presence_of :password, on: :create
  validates_confirmation_of :password
  validates_presence_of :email
  validates_presence_of :name
  validates_uniqueness_of :email

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = find_by_email(email.downcase)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def available_planners(competition)
    self.planners.select{
      |planner| not competition.planners.include?(planner) and planner.status == 'verified'
    }
  end

  def available_planners?(competition)
    available_planners(competition).any?
  end
  
end
