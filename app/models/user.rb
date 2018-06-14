class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :connection
  has_many :sources, dependent: :destroy

  after_create :create_connection

  def self.find_user_with_state state
    User.find state.to_i
  end

  def create_connection
    Connection.create user_id: id
  end
end
