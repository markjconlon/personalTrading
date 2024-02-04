class Owner < ApplicationRecord
  has_many :accounts

  def name
    "#{firstname} #{lastname}"
  end
end
