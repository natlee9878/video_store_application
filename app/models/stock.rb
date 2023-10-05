class Stock < ApplicationRecord
  belongs_to :videos, optional: true
  enum format_type: { DVD: 1, Blu_ray: 2, VHS: 3 }
end