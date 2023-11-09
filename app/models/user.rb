class User < ApplicationRecord
  has_many :rental
  enum role: { regular: 'regular', admin: 'admin' }
  validates :first_name, presence: true
  scope :search_by_name, ->(name) {
    where("first_name LIKE :name OR last_name LIKE :name", name: "%#{name}%")
  }
  scope :active_status, -> (status) { where(active: status) if status.present? }
  humanize :active, boolean: true
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
