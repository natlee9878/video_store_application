class User < ApplicationRecord
  enum role: { regular: 'regular', admin: 'admin' }
  validates :first_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum state: {
    ACT: 1,
    NSW: 2,
    NT: 3,
    QLD: 4,
    SA: 5,
    TAS: 6,
    VIC: 7,
    WA: 8
  }
end
