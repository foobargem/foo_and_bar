# == Schema Information
#
# Table name: admins
#
#  id                 :integer(4)      not null, primary key
#  email              :string(255)     default(""), not null
#  encrypted_password :string(128)     default(""), not null
#  sign_in_count      :integer(4)      default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  login              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :login

end
