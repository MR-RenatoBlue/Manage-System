class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  after_create :assign_default_role

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def active_for_authentication?
    super and self.is_active?
  end
  def inactive_message
    is_active? ? super : :account_inactive
  end

  def self.search(search)
    if search
      user_by_email = User.where("email like ?", "%#{search}%")
      if user_by_email
        self.where(id: user_by_email)
      else
        @users = User.all
      end
    else
      @users = User.all
    end
  end
end
